class TeamInbox < ActiveRecord::Base
  belongs_to :team, inverse_of: :team_inboxes
  belongs_to :inbox, inverse_of: :team_inboxes

  validates :order, presence: true
  validates_uniqueness_of :order, scope: :team
end
