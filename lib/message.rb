class Message

  InvalidMessage = Class.new(StandardError)

  class Subject
    attr_accessor :role_type, :subject_type, :friendly_name, :uuid
    def initialize(subject_hash)
      [:role_type, :subject_type, :friendly_name, :uuid].each do |attribute|
        send("#{attribute}=",subject_hash[attribute.to_s])
      end
    end
  end

  module ClassMethods

    attr_reader :event_nested_attributes

    def from_json(json)
      begin
        new(JSON.parse(json))
      rescue JSON::ParserError
        raise InvalidMessage
      end
    end

  end

  extend ClassMethods

  attr_reader :lims,:occured_at, :subjects
  attr_accessor :metadata, :event_type

  def initialize(event_hash)
    raise InvalidMessage if event_hash['lims'].nil? || event_hash['event'].nil?
    @lims = event_hash['lims']
    [:metadata,:event_type,:occured_at,:subjects].each do |attribute|
      send("#{attribute}=",event_hash.fetch('event')[attribute.to_s])
    end
  end

  def occured_at=(date_time)
    begin
      @occured_at = DateTime.parse(date_time)
    rescue ArgumentError
      raise InvalidMessage, "Unrecognised date format: #{date_time}"
    end
  end

  def subjects=(subjects)
    raise InvalidMessage unless subjects.respond_to?(:each)
    @subjects = subjects.map do |subject|
      Subject.new(subject)
    end
  end

  def fetch_metadata(key)
    metadata.fetch(key)
  end

  def subjects_with_role(role)
    subjects.select {|s| s.role_type == role }
  end
end
