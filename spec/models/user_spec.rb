require 'rails_helper'

RSpec.describe User, type: :model do
  it 'requires a login' do
    user = build :user, login: nil
    expect(user).to_not be_valid
    expect(user.errors[:login]).to include("can't be blank")
  end
end
