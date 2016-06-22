require 'rails_helper'

RSpec.describe Team, type: :model do


  let(:valid_attributes) {
    {
      key: generate(:team_key)
    }
  }

  it "enforces a unique key" do
    existing_team = create :team
    new_team = Team.new(valid_attributes.merge(key:existing_team.key))
    expect(new_team).to_not be_valid
    expect(new_team.errors[:key]).to include("has already been taken")
  end

  it "requires a unique key" do
    new_team = Team.new(valid_attributes.merge(key: nil))
    expect(new_team).to_not be_valid
    expect(new_team.errors[:key]).to include("can't be blank")
  end

  it "converts names to keys" do
    new_team = Team.new(name:'Team A')
    expect(new_team.key).to eq('team-a')
  end

  it "converts keys to names" do
    new_team = Team.new(key:'team_a')
    expect(new_team.name).to eq('Team A')
  end

  it "restricts special characters in team names" do
    new_team = Team.new(name: 'Illegal! name')
    expect(new_team).to_not be_valid
    expect(new_team.errors[:name]).to include("can only contain letters, spaces and numbers")
  end
end
