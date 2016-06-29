class Batch < ActiveRecord::Base
  belongs_to :user
  has_many :items, inverse_of: :batch

  validates :user, presence: true
end
