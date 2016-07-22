
# A processor wraps up the checkpoints
# handling of message processing, different
# processors handle entry and exit
class Checkpoint::Processor

  attr_reader :checkpoint, :message

  def initialize(checkpoint,message)
    @checkpoint = checkpoint
    @message = message
  end

  def check
    return false unless message.event_type == event_type
    conditions.fetch(:metadata,[]).all? do |key,comparison_value|
      comparison_value.all? do |comparison,value|
        case comparison.to_s
        when 'eq'
          message.fetch_metadata(key) == value
        when 'in'
          value.include?(message.fetch_metadata(key))
        else
          raise UnknownComparison, "Unknown comparison: #{comparison}"
        end
      end
    end
  end

  delegate :subject_role, :inbox, :conditions, :event_type, to: :checkpoint

end
