require 'rails_helper'

RSpec.describe Inbox, type: :model do

  let(:valid_attributes) {
    {
      key: generate(:inbox_name)
    }
  }

  it "will auto generate a unique key" do
    existing_inbox = create :inbox, name: 'example', key: 'example'
    new_inbox = Inbox.new(name: 'example')
    expect(new_inbox).to be_valid
    expect(new_inbox.key).to_not eq('example')
  end

  it "requires a key" do
    new_inbox = Inbox.new(valid_attributes.merge(key: nil))
    expect(new_inbox).to_not be_valid
    expect(new_inbox.errors[:key]).to include("can't be blank")
  end

  it "converts names to keys" do
    new_inbox = Inbox.new(name:'Inbox A')
    expect(new_inbox.key).to eq('inbox-a')
  end

  it "requires a name that can be parameterized" do
    new_inbox = Inbox.new(name: '!"$%')
    expect(new_inbox).to_not be_valid
    expect(new_inbox.errors[:name]).to include("must contain at least one letter or number")
  end

end
