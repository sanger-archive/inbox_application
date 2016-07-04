require 'rails_helper'

RSpec.describe "inboxes/_inbox", type: :view do

  let(:inbox) { build(:inbox) }
  let(:item_a) { build :item, inbox: inbox }
  let(:item_b) { build :item, inbox: inbox }
  let(:items) {
    [item_a,item_b]
  }


  it "renders the inbox view" do
    render partial: "inboxes/inbox", locals: { inbox: inbox, items: items }
    assert_select "#item-list>li h4", :text => item_a.name, :count => 1
    assert_select "#item-list>li h4", :text => item_b.name, :count => 1
  end

end
