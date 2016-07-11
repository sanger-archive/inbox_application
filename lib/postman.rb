# A postman listens to a rabbitMQ message queues
# and funnels messages onto it.
require 'bunny'
require_relative 'message'

class Postman

  class Consumer < Bunny::Consumer
  end

  CACHE_CONFIG_FOR = 60

  LOCAL_RABBIT = 'amqp://localhost:5672'
  attr_reader :client, :queue_name, :exchange_name, :routing_keys

  def initialize(amqp_url:LOCAL_RABBIT,queue_name:,exchange_name:,routing_keys:,consumer_tag:nil)
    @client = Bunny.new(amqp_url)
    @stopped = false
    @queue_name = queue_name.dup.freeze
    @exchange_name = exchange_name.dup.freeze
    @routing_keys = routing_keys.map {|k| k.dup.freeze}
    @consumer_tag = consumer_tag || "#{@queue_name}_#{Rails.env}_#{Process.pid}"
    @state = :initialized
  end

  def stopping?
    @state == :stopping
  end

  def alive?
    @state != :stopped
  end

  def channel
    @channel ||= @client.create_channel
  end

  def exchange
    channel.topic(exchange_name, :auto_delete => false, :durable => true)
  end

  def queue
    channel.queue(queue_name)
  end

  def checkpoints
    return @checkpoints if @checkpoints && ((Time.now - @checkpoints_cache) < CACHE_CONFIG_FOR)
    @checkpoints_cache = Time.now
    @checkpoints = Checkpoint.all
  end

  def establish_bindings!
    routing_keys.each do |key|
      queue.bind(exchange,routing_key:key)
    end
  end

  def run!

    @state = :starting

    # Capture the term signal and set the state to stopping.
    # We can't directly cancel the consumer from here as Bunny
    # uses Mutex locking while checking the state. Ruby forbids this
    # from inside a trap block.
    Signal.trap("TERM") do
      @state = :stopping
      puts "Stopping #{@consumer_tag}"
    end

    # We reconnect to the database after the fork.
    ActiveRecord::Base.establish_connection
    @client.start
    establish_bindings!

    @state = :running

    # Our consumer operates in another thread. It is non blocking.
    # While a blocking consumer would be convenient, it causes problems:
    # 1. @consumer never gets set, requiring up instead to instantiate it first, then use subscribe_with
    # 2. We are still unable to call @consumer.cancel in our trap, give the aforementioned restrictions
    # 3. However, as our main thread is locked, we don't have anywhere else to handle the shutdown from
    # 4. There doesn't seem to be much gained from spinning up the control loop in its own thread
    @consumer = queue.subscribe(:manual_ack => true, :block=>false, :consumer_tag=>@consumer_tag) do |delivery_info, metadata, payload|
      process(delivery_info,payload)
    end

    # The control loop. Checks the state of the process every three seconds
    # stopping: cancels the consumer, sets the processes to stopped and breaks the loop
    # stopped: (alive? returns false) terminates the loop. In practice the break should have achieved this
    # anything else: waits three seconds and tries again
    while alive? do
      if stopping?
        @consumer.cancel
        @state = :stopped
        break
      end
      sleep(3)
    end

    # And we leave the application
    puts "Stopped #{@consumer_tag}"
    puts "Goodbye!"

  ensure
    @client.close
  end

  def process(delivery_info,payload)
    begin
      message = Message.from_json(payload)
    rescue Message::InvalidMessage => e
      channel.nack(delivery_info.delivery_tag)
      return
    end

    checkpoints.each do |checkpoint|
      processor = checkpoint.processor(message)
      next unless processor.check
      processor.process
    end

    channel.ack(delivery_info.delivery_tag)
  end
end
