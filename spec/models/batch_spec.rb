require 'rails_helper'

RSpec.describe Batch, type: :model do
  it "requires a user" do
    batch = build :batch, user: nil
    expect(batch).to_not be_valid
    expect(batch.errors[:user]).to include("can't be blank")
  end

  it "can have multiple items" do
    batch = build :batch
    2.times { batch.items << build(:item) }
    expect(batch.items.size).to eq(2)
  end
end
