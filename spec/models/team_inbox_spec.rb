require 'rails_helper'

RSpec.describe TeamInbox, type: :model do

  it "should require an order" do
    team_inbox = build :team_inbox, order: nil
    expect(team_inbox).to_not be_valid
    expect(team_inbox.errors[:order]).to include('must be set for each inbox')
  end

  it "should check that order is unique within a team" do
    team_inbox = create :team_inbox, order: 1
    team_inbox2 = build :team_inbox, order: 1, team: team_inbox.team
    expect(team_inbox2).to_not be_valid
    expect(team_inbox2.errors[:order]).to include('must be unique for each inbox')
  end

  it "should accept the same order across different teams" do
    team_inbox = create :team_inbox, order: 1
    team_inbox2 = build :team_inbox, order: 1
    expect(team_inbox2).to be_valid
  end
end
