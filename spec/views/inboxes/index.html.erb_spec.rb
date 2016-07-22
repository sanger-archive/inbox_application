require 'rails_helper'

RSpec.describe "inboxes/index", type: :view do
  before(:each) do
    assign(:inboxes, [
      create(:inbox),
      create(:inbox)
    ])
  end

  it "renders a list of inboxes" do
    render
  end
end
