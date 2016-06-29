class Item < ActiveRecord::Base
  belongs_to :batch, inverse_of: :items
  belongs_to :inbox, inverse_of: :items

  serialize :details

  validates :inbox, presence: true
end
