class Team < ActiveRecord::Base

  include KeyFromName

  validates :key, presence: true, uniqueness: true
  validates :name, format: { with: /[a-zA-Z0-9]+/ }

end
