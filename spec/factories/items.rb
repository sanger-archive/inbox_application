FactoryGirl.define do

  sequence :item_name do |i|
    "item #{i}"
  end

  factory :item do
    uuid { SecureRandom.uuid }
    name { generate :item_name }
    details({
      :primary_details => {'Key A'=>'Value A'},
      :secondary_details=>{'Key B'=>'Value B'},
      :primary_associations => {'association'=>['one','two']},
      :secondary_associations => {'association_2'=>['three','four']}
    })
    inbox

    factory :pending_item do
       # Essentially the same as item
    end

    factory :batched_item do
      batch
    end

    factory :completed_item do
      batch
      completed_at "2016-06-29 09:31:41"
    end
  end
end
