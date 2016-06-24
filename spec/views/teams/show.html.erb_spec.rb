require 'rails_helper'

RSpec.describe "teams/show", type: :view do
  before(:each) do
    @team = assign(:team, Team.create!(
      :name => "Name"
    ))
  end

  it "shows a helpful prompt if there are no inboxes" do
    render
    assert_select "div.jumbotron>h1", :text => "There's nothing here..."
    assert_select "a.btn", text: "Set up this team", href: edit_team_path(@team)
  end

  it "shows a list of tabs if there are inboxes" do
    t_i = create :team_inbox, team: @team, order: 1
    t_i2 = create :team_inbox, team: @team, order: 2
    inbox = t_i.inbox
    inbox2 = t_i2.inbox
    @active_inbox = inbox
    render
    assert_select ".inbox-list>.inbox-tab", :text => inbox.name
    assert_select ".inbox-list>.inbox-tab", :text => inbox2.name
  end
end
