class Inbox < ActiveRecord::Base

  has_many :team_inboxes
  has_many :teamms, through: :team_inboxes

end
