class InboxSerializer

  InvalidFile = Class.new(StandardError)

  CHECKPOINT_INTERFACE = {'checkpoints'=>{
    only:['direction','event_type','subject_role'],
    methods:['metadata','primary_details','secondary_details','primary_associations','secondary_associations']
    }
  }

  INBOX_INTERFACE = { inbox:{
        only:['name'],
        include:[ CHECKPOINT_INTERFACE ]
      }
    }

  ROOT_ATTRIBUTES = {'timestamp' => nil, 'inbox_app_inbox'=>nil}

  module ClassMethods
    def deserialize(payload)
      begin
        InboxSerializer.new.from_json(payload).inbox
      rescue JSON::ParserError
        raise InvalidFile
      end
    end
  end
  extend ClassMethods

  include ActiveModel::Serializers::JSON

  attr_reader :inbox

  def initialize(inbox=nil)
    @inbox = inbox || Inbox.new
  end

  def serialize
    to_json(include: INBOX_INTERFACE )
  end


  private

  # Oddly the basic from_json implementation passes the JSOn straight to
  # .attributes= which means you potentially allow the user to update any
  # attribute accessible through an assignment method. I could probably
  # use permitted parameters here, but seeing as I've already defined my
  # API for the serialization, I'll use the same spec in reverse to filter
  # my attributes hash.

  # A list of the attributes that can be updated though the interface
  def inbox_attributes
    INBOX_INTERFACE.dig(:inbox,:only)
  end

  def checkpoint_attributes
    CHECKPOINT_INTERFACE.dig('checkpoints',:only) + CHECKPOINT_INTERFACE.dig('checkpoints',:methods)
  end

  def attributes=(new_attributes)
    raise InvalidFile unless new_attributes['inbox_app_inbox'] == inbox_app_inbox
    new_inbox_attributes = new_attributes.fetch('inbox',{}).select {|k,v| inbox_attributes.include?(k) }
    inbox.update_attributes(new_inbox_attributes)
    new_checkpoints = (new_attributes.dig('inbox','checkpoints')||[]).map {|checkpoint| checkpoint.select {|k,v| checkpoint_attributes.include?(k) } }
    inbox.checkpoints.clear
    inbox.checkpoints.build(new_checkpoints)
    inbox.save
  end

  def timestamp
    inbox.updated_at.to_s(:number)
  end

  def inbox_app_inbox
    'v1'
  end

  def attributes
    ROOT_ATTRIBUTES
  end


end
