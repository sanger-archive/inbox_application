require 'rails_helper'

RSpec.describe "teams/index", type: :view do
  before(:each) do
    assign(:teams, [
      Team.create!(
        :name => "Name"
      ),
      Team.create!(
        :name => "Name2"
      )
    ])
  end

  it "renders a list of teams" do
    render
    assert_select "div.team-list>a>h4", :text => "Name".to_s, :count => 1
    assert_select "div.team-list>a>h4", :text => "Name2".to_s, :count => 1
  end

  it "renders a create team link" do
    render
    assert_select "a", :text => "Add a new team", href: new_team_path
  end
end
