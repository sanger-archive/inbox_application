FactoryGirl.define do

  sequence :team_key do |i|
    "team-#{i}"
  end


  sequence :team_name do |i|
    "Team #{i}"
  end

  factory :team do
    name { generate :team_name }
    key { generate :team_key }
  end
end
