class Batch < ApplicationRecord
  belongs_to :user
  has_many :items, inverse_of: :batch, dependent: :nullify

  attr_reader :user_swipecard

  # In practice, this will almost always be just one inbox.
  has_many :inboxes, ->() { distinct }, through: :items

  validates :user, presence: true
  # If we don't have a user, check that we at least have a swipecard
  validates :user_swipecard, presence: true, unless: :user
  validate :vaild_swipecard_code, :if => :user_swipecard

  def user_swipecard=(swipecard)
    @user_swipecard = true
    self.user = User.find_with_swipecard(swipecard)
  end

  private

  def vaild_swipecard_code
    return true if user.present?
    errors.add(:user_swipecard,I18n.t(:unrecognized,scope:[:activerecord,:errors,:models,:batch,:attributes,:user_swipecard]))
  end

end
