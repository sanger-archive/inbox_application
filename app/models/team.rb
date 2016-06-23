class Team < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :name, format: { with: /[a-zA-Z0-9]+/ }
  before_validation :generate_key, unless: :key?

  def to_param; key; end

  def key
    super || generate_key
  end

  private

  def generate_key
    self.key = name && name.parameterize
  end

end
