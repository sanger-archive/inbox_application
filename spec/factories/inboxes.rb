FactoryGirl.define do

  sequence :inbox_name do |i|
    "Inbox #{i}"
  end

  sequence :inbox_key do |i|
    "inbox-#{i}"
  end

  factory :inbox do
    display_name { generate :inbox_name }
    key { generate :inbox_key }
  end
end
