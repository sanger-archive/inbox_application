require 'rails_helper'
require 'byebug'
RSpec.describe Item, type: :model do

  let(:pending_item) { create :pending_item, name: 'pending_item' }
  let(:batched_item) { create :batched_item , name: 'batched_item'}
  let(:completed_item) { create :completed_item, name: 'completed_item' }
  let(:with_a_full_set_of_items) { pending_item.save!; batched_item.save!; completed_item.save!; }

  it 'has serializable details' do
    item = create :item
    expect(item.details[:primary_details]).to eq({'Key A'=>'Value A'})
    item.reload
    expect(item.details[:primary_details]).to eq({'Key A'=>'Value A'})
  end

  it 'can return pending items' do
    with_a_full_set_of_items
    expect(Item.pending.all).to eq([pending_item])
  end

  it 'can return batched items' do
    expect(batched_item.batch).to be_a(Batch)
    with_a_full_set_of_items
    expect(Item.batched.all).to eq([batched_item])
  end

  it 'can return completed items' do
    with_a_full_set_of_items
    expect(Item.completed.all).to eq([completed_item])
  end

  it 'can provide an elegant filter to make controllers nicer' do
    with_a_full_set_of_items
    expect(Item.which_are(:completed).all).to eq([completed_item])
    expect(Item.which_are(:batched).all).to eq([batched_item])
    expect(Item.which_are(:pending).all).to eq([pending_item])
  end
end
