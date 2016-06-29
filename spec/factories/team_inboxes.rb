FactoryGirl.define do

  sequence :order do |i|
    i
  end

  factory :team_inbox do
    team
    inbox
    order
  end
end
