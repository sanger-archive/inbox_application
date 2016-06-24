class Team < ActiveRecord::Base

  include KeyFromName

  scope :alphabetical, ->() { order(key: :asc) }

  has_many :team_inboxes, ->() { order(order: :asc) }, inverse_of: :team
  has_many :inboxes, through: :team_inboxes, inverse_of: :teams

end
