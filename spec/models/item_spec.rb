require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'has serializable details' do
    item = create :item
    expect(item.details[:primary_details]).to eq({'Key A'=>'Value A'})
    item.reload
    expect(item.details[:primary_details]).to eq({'Key A'=>'Value A'})
  end
end
