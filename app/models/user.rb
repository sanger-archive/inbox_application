class User < ApplicationRecord
  validates :login, presence: true
  alias_attribute :uuid, :id

  # Must point to an object that responds to find with a swipecard and returns a has appropriate for input creation
  class_attribute :external_service
  # Ideally we'd do this with an initializer, but rails class reloading makes dependency injection tricky
  self.external_service = SequencescapeSearch::Search.new(Rails.configuration.api_root,SequencescapeSearch.swipecard_search)


  def self.find_with_swipecard(swipecard)
    external_params = self.external_service.find(swipecard)
    return nil if external_params.nil?
    uuid = external_params.delete(:uuid)
    User.create_with(external_params).find_or_create_by(uuid:uuid)
  end

end
