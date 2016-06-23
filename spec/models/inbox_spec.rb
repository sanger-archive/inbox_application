require 'rails_helper'

RSpec.describe Inbox, type: :model do

  let(:valid_attributes) {
    {
      key: generate(:inbox_name)
    }
  }

end
