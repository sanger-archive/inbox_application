require 'rails_helper'

RSpec.describe "teams/edit", type: :view do

  before(:each) do
    @team = create :team_with_inbox
  end

  it "renders the edit team form" do
    render

    assert_select "form[action=?][method=?]", team_path(@team), "post" do
      assert_select "input#team_name[name=?]", "team[name]"
    end
  end

  it "renders the edit inboxes form" do

    @other_inboxes = [create(:inbox)]

    render

    assert_select "ol#edit-inbox-list>li", count: 1
    assert_select "ul#other-inbox-list>li", count: 1
  end
end
