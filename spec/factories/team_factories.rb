FactoryGirl.define do

  sequence :team_key do |i|
    "team-#{i}"
  end

  factory :team do
    key { generate :team_key }
  end
end
