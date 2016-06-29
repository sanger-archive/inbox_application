FactoryGirl.define do

  sequence :item_name do |i|
    "item #{i}"
  end

  factory :item do
    name { generate :item_name }
    details({
      :primary_details => {'Key A'=>'Value A'},
      :secondary_details=>{'Key B'=>'Value B'},
      :primary_associations => {'association'=>['one','two']},
      :secondary_associations => {'association_2'=>['three','four']}
    })
    batch
    inbox
    completed_at "2016-06-29 09:31:41"
  end
end
