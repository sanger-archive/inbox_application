FactoryGirl.define do

  factory :message do

    event_type 'event_type'
    lims 'lims'
    occured_at { DateTime.now }
    metadata({'key'=>'value'})
    subjects []

    skip_create
    initialize_with { Message.new(attributes) }
  end

  factory :subject, class: 'Message::Subject' do
    skip_create
    initialize_with { Message::Subject.new(attributes) }
  end
end
