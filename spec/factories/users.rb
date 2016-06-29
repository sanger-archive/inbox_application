FactoryGirl.define do

  sequence :login do |i|
    "ab#{i}"
  end

  factory :user do
    login
  end
end
