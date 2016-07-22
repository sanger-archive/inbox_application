FactoryGirl.define do

  sequence :inbox_name do |i|
    "Inbox #{i}"
  end

  sequence :inbox_key do |i|
    "inbox-#{i}"
  end

  factory :inbox do
    name { generate :inbox_name }
    key { generate :inbox_key }

    factory :full_inbox do
      after :build do |inbox,evaluator|
        inbox.checkpoints = [
          build(:entry_checkpoint,inbox:inbox),
          build(:exit_checkpoint,inbox:inbox)
        ]
      end
    end
  end
end
