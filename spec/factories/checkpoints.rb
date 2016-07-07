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
  end
end
