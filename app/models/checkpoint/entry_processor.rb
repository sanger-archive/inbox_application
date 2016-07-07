class Checkpoint::EntryProcessor < Checkpoint::Processor
  def process
    message.subjects_with_role(subject_role).each do |subject|
      inbox.items.create_with({
        name: subject.friendly_name,
        details: extract_details
      }).find_or_create_by!(uuid: subject.uuid)
    end
  end

  private

  def extract_details
    # primary_details: Array,
    # secondary_details: Array,
    # primary_associations: Array,
    # secondary_associations: Array
    {
      primary_details: message.metadata_for(conditions.fetch(:primary_details,[])),
      secondary_details: message.metadata_for(conditions.fetch(:secondary_details,[])),
      primary_associations: subjects_for(conditions.fetch(:primary_associations,[])),
      secondary_associations: subjects_for(conditions.fetch(:secondary_associations,[]))
    }
  end

  def subjects_for(roles)
    Hash[roles.map do |role|
      [role, message.subjects_with_role(role).map(&:friendly_name)]
    end]
  end
end
