class Message

  InvalidMessage = Class.new(StandardError)

  class Subject
    attr_accessor :role_type, :subject_type, :friendly_name, :uuid
    def initialize(subject_hash)
      subject_hash.stringify_keys!
      ['role_type', 'subject_type', 'friendly_name', 'uuid'].each do |attribute|
        send("#{attribute}=",subject_hash[attribute])
      end
    end
  end

  module ClassMethods

    attr_reader :event_nested_attributes

    def from_json(json)
      begin
        parameters = JSON.parse(json)
        extracted_event = parameters.delete('event') || raise(InvalidMessage)
        parameters.merge!(extracted_event)
        new(parameters)
      rescue JSON::ParserError
        raise InvalidMessage
      end
    end

  end

  extend ClassMethods

  attr_reader :occured_at, :subjects
  attr_accessor :metadata, :event_type, :lims

  def initialize(event_hash)
    event_hash.stringify_keys!
    ['metadata','event_type','occured_at','subjects','lims'].each do |attribute|
      send("#{attribute}=",event_hash[attribute])
    end
  end

  def occured_at=(date_time)
    begin
      @occured_at = date_time.is_a?(String) ? DateTime.parse(date_time) : date_time
    rescue ArgumentError
      raise InvalidMessage, "Unrecognised date format: #{date_time}"
    end
  end

  def subjects=(subjects)
    raise InvalidMessage unless subjects.respond_to?(:each)
    @subjects = subjects.map do |subject|
      subject.is_a?(Subject) ? subject : Subject.new(subject)
    end
  end

  def fetch_metadata(key)
    metadata.fetch(key)
  end

  def metadata_for(keys)
    metadata.select {|k,v| keys.include?(k) }
  end

  def subjects_with_role(role)
    subjects_by_role[role]
  end

  def subjects_by_role
    @subjects_by_role ||= subjects.group_by(&:role_type)
  end
end
