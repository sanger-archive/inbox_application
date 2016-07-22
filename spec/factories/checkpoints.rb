FactoryGirl.define do
  factory :checkpoint do
    inbox
    direction "entry"
    subject_role "package"
    event_type "delivery"
    conditions({
      metadata: { 'delivery_method' => { eq: 'courier' }},
      primary_details: ['deliver_method'],
      secondary_details: ['shipping_cost'],
      primary_associations: ['sender'],
      secondary_associations: ['recipient']
    })

    factory :entry_checkpoint do
    end

    factory :exit_checkpoint do
      direction 'exit'
    end
  end
end
