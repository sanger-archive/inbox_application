class Item < ActiveRecord::Base
  belongs_to :batch, inverse_of: :items
  belongs_to :inbox, inverse_of: :items

  serialize :details

  validates :inbox, presence: true
  validates :uuid, presence: true

  # Pending items are those that have been completed or batched
  scope :pending, ->() { where(completed_at: nil, batch_id: nil) }
  # batched items have been added to a batch, but are incomplete
  scope :batched, ->() { where(completed_at: nil).where.not(batch_id:nil) }
  # compleded items have a completed at timestamp. Them may have never been added
  # to a batch.
  scope :completed, ->() { where.not(completed_at: nil) }

  # Lets the controller pass the scope in as an argument.
  # We don't use 'send' as that would let someone do something naughty,
  # like request inbox?state=destroy_all
  scope :which_are, ->(state) {
    case state.to_s
    when 'pending' then pending
    when 'batched' then batched
    when 'completed' then completed
    else none
    end
  }

  # Primary details are the metadata that you want displayed without needing
  # to click 'more'
  def each_primary_detail(&block)
    details.fetch(:primary_details,[]).each(&block)
  end

  # Secondary details are less important. They probably won't be rendered upfront
  def each_secondary_detail
    details.fetch(:secondary_details,[]).each(&block)
  end


  # Primary details are the metadata that you want displayed without needing
  # to click 'more'
  def each_primary_association(&block)
    details.fetch(:primary_associations,[]).each(&block)
  end

  # Secondary details are less important. They probably won't be rendered upfront
  def each_secondary_association
    details.fetch(:secondary_associations,[]).each(&block)
  end
end
