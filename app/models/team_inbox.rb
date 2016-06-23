class TeamInbox < ActiveRecord::Base
  belongs_to :team
  belongs_to :inbox
end
