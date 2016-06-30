class Item < ActiveRecord::Base
  belongs_to :batch, inverse_of: :items
  belongs_to :inbox, inverse_of: :items

  serialize :details

  validates :inbox, presence: true
  validates :uuid, presence: true

  scope :pending, ->() { where(completed_at: nil, batch_id: nil) }
  scope :batched, ->() { where(completed_at: nil).where.not(batch_id:nil) }
  scope :completed, ->() { where.not(completed_at: nil).where.not(batch_id:nil) }

  # Lets the controller pass the scope in as an argument.
  # We don't use 'send' as that would let someone do something naughty,
  # like request inbox?state=destroy_all
  scope :which_are, ->(state) {
    case state.to_s
    when 'pending' then pending
    when 'batched' then batched
    when 'completed' then completed
    else where(false)
    end
  }
end
