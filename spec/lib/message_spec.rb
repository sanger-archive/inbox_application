require 'byebug'
require 'rails_helper'
require './lib/message'

RSpec.describe Message, type: :lib do

  # Taken from the event warehouse documentation
  let(:message_json) {
    %Q{{
      "event":{
        "uuid":"00000000-1111-2222-3333-444444444444",
        "event_type":"delivery",
        "occured_at":"2012-03-11 10:22:42",
        "user_identifier":"postmaster@example.com",
        "subjects":[
          {
            "role_type":"sender",
            "subject_type":"person",
            "friendly_name":"alice@example.com",
            "uuid":"00000000-1111-2222-3333-555555555555"
          },
          {
            "role_type":"recipient",
            "subject_type":"person",
            "friendly_name":"bob@example.com",
            "uuid":"00000000-1111-2222-3333-666666666666"
          },
          {
            "role_type":"package",
            "subject_type":"plant",
            "friendly_name":"Chuck",
            "uuid":"00000000-1111-2222-3333-777777777777"
          }
        ],
        "metadata":{
          "delivery_method":"courier",
          "shipping_cost":"15.00"
        }
      },
      "lims":"example"
    }}
  }

  let(:invalid_json) { '#%2' }

  let(:message_from_json) { Message.from_json(message_json) }
  let(:first_package) { message_from_json.subjects_with_role('package').first }

  it "can be created from json" do
    expect(message_from_json).to be_a(Message)
  end

  it 'raises InvalidMessage with invalid Json' do
    expect { Message.from_json(invalid_json) }.to raise_error(Message::InvalidMessage)
  end

  it '#lims returns the lims' do
    expect(message_from_json.lims).to eq("example")
  end

  it '#metadata returns a hash of metadata' do
    expect(message_from_json.metadata).to eq({
      'delivery_method' => 'courier',
      'shipping_cost'   => '15.00'
    })
  end

  it '#fetch_metadata("shipping_cost") returns "15.00"' do
    expect(message_from_json.fetch_metadata('shipping_cost')).to eq("15.00")
  end

  it '#event_type returns "delivery"' do
    expect(message_from_json.event_type).to eq('delivery')
  end

  it '#occured_at returns the right DateTime' do
    expect(message_from_json.occured_at).to eq(DateTime.new(2012,03,11,10,22,42))
  end

  it '#subjects returns an array of Subjects' do
    expect(message_from_json.subjects).to be_an(Array)
    expect(message_from_json.subjects.first).to be_a(Message::Subject)
  end

  it '#subjects_with_role(package) returns an array with just chuck' do
    expect(message_from_json.subjects_with_role('package')).to be_an(Array)

    expect(first_package.uuid).to eq("00000000-1111-2222-3333-777777777777")
    expect(first_package.friendly_name).to eq("Chuck")
    expect(first_package.subject_type).to eq('plant')
    expect(first_package.role_type).to eq('package')
  end

  # These don't belong here. Move the basics out to the conditions
  # it "#has_metadata?('shipping_cost',eq:'15.00') returns true" do
  #   expect(message_from_json.has_metadata?('shipping_cost',eq:'15.00')).to be_true
  # end

  # it "#has_metadata?('penguin_import_license',eq:true) returns false" do
  #   expect(message_from_json.has_metadata?('penguin_import_license',eq:'15.00')).to be_false
  # end

  # it "#has_metadata?('delivery_method',eq:'carrier_pidgeon') returns false" do
  #   expect(message_from_json.has_metadata?('delivery_method',eq:'carrier_pidgeon')).to be_false
  # end

  # it "#has_metadata?('delivery_method',in:['carrier_pidgeon','courier']) returns true" do
  #   expect(message_from_json.has_metadata?('delivery_method',eq:['carrier_pidgeon','courier'])).to be_true
  # end


end
