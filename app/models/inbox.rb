class Inbox < ApplicationRecord

  include KeyFromName

  has_many :team_inboxes, inverse_of: :inbox
  has_many :teams, through: :team_inboxes, inverse_of: :inboxes
  has_many :items, inverse_of: :inbox
  has_many :checkpoints, inverse_of: :inbox

  def status
    *checks = team_inboxes.exists?, checkpoints.entry.exists?, checkpoints.exit.exists?
    case checks
    when [true,true,true]
      :active
    when [false,false,false]
      :deprecated
    when [true,false,false]
      :inactive
    when [true,false,true]
      :draining
    when [true,true,false]
      :exitless
    else
      :detached
    end
  end

  def deactivate!
    checkpoints.destroy_all
  end

  def serialize
    InboxSerializer.new(self).serialize
  end

  def self.deserialize(payload)
    Inbox.new.from_json(payload)
  end

  def timestamped_key
    "#{key}_#{updated_at.to_s(:number)}"
  end

end
