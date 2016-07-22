require 'rails_helper'

RSpec.describe "inboxes/edit", type: :view do
  before(:each) do
    @inbox = assign(:inbox, create(:inbox))
  end

  it "renders the edit inbox form" do
    render

    assert_select "form[action=?][method=?]", inbox_path(@inbox), "post" do
    end
  end
end
