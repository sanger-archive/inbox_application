require 'rails_helper'

RSpec.describe "inboxes/new", type: :view do
  before(:each) do
    assign(:inbox, Inbox.new())
  end

  it "renders new inbox form" do
    render

    assert_select "form[action=?][method=?]", inboxes_path, "post" do
    end
  end
end
