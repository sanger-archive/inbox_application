class Checkpoint::ExitProcessor < Checkpoint::Processor
  def process
    message.subjects_with_role(subject_role).each do |subject|
      inbox.items.where(uuid: subject.uuid ).find_each {|item| item.completed_at = message.occured_at; item.save! }
    end
  end
end
