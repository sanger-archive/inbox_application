class Team < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :name, format: { with: /\A[a-zA-Z0-9 ]+\z/ }

  def to_param; key; end

  def name=(name)
    return name if name.blank?
    @name = name
    self.key = name.parameterize
  end

  def name
    @name ||= key && key.titleize
  end
end
