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

    transient do
      inbox_count 1
    end


    factory :team_with_inbox do

      after :build do |team, evaluator|
        evaluator.inbox_count.times { create :team_inbox, team: team }
      end
    end
  end

end
