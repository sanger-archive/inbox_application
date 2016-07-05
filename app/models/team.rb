class Team < ApplicationRecord

  include KeyFromName

  scope :alphabetical, ->() { order(key: :asc) }

  has_many :team_inboxes, ->() { order(order: :asc) }, inverse_of: :team, dependent: :destroy
  has_many :inboxes, through: :team_inboxes, inverse_of: :teams

  def team_inboxes_attributes=(attributes)
    included_inboxes = attributes.values.reject {|team_inbox| team_inbox[:order].blank? }
    team_inboxes.clear
    team_inboxes.build(included_inboxes)
  end

end
