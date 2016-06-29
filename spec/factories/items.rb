FactoryGirl.define do
  factory :item do
    name "ItemName"
    details({:some => 'details'}.to_yaml)
    batch
    completed_at "2016-06-29 09:31:41"
  end
end
