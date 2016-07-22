require 'rails_helper'

RSpec.describe Inbox, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  let(:valid_attributes) {
    {
      key: generate(:inbox_name)
    }
  }

  it "will auto generate a unique key" do
    existing_inbox = create :inbox, name: 'example', key: 'example'
    new_inbox = Inbox.new(name: 'example')
    expect(new_inbox).to be_valid
    expect(new_inbox.key).to_not eq('example')
  end

  it "requires a key" do
    new_inbox = Inbox.new(valid_attributes.merge(key: nil))
    expect(new_inbox).to_not be_valid
    expect(new_inbox.errors[:key]).to include("can't be blank")
  end

  it "converts names to keys" do
    new_inbox = Inbox.new(name:'Inbox A')
    expect(new_inbox.key).to eq('inbox-a')
  end

  it "requires a name that can be parameterized" do
    new_inbox = build :inbox, name: '!"$%'
    expect(new_inbox).to_not be_valid
    expect(new_inbox.errors[:name]).to include("must contain at least one letter or number")
  end

  context 'with a team' do

    let(:core_inbox) {
      inbox = create :inbox
      create :team_inbox, inbox: inbox
      inbox
    }

    context 'and both criteria' do

      let(:inbox) {
        create :entry_checkpoint, inbox: core_inbox
        create :exit_checkpoint, inbox: core_inbox
        core_inbox
      }

      it '#status' do
        expect(inbox.status).to eq(:active)
      end
    end

    context 'and entry criteria' do

      let(:inbox) {
        create :entry_checkpoint, inbox: core_inbox
        core_inbox
      }

      it '#status' do
        expect(inbox.status).to eq(:exitless)
      end
    end

    context 'and exit criteria' do

      let(:inbox) {
        create :exit_checkpoint, inbox: core_inbox
        core_inbox
      }

      it '#status' do
        expect(inbox.status).to eq(:draining)
      end
    end

    context 'and no criteria' do

      let(:inbox) {
        core_inbox
      }

      it '#status' do
        expect(inbox.status).to eq(:inactive)
      end

    end

  end

  context 'without a team' do

    let(:core_inbox) {
      create :inbox
    }

    context 'and both criteria' do

      let(:inbox) {
        create :entry_checkpoint, inbox: core_inbox
        create :exit_checkpoint, inbox: core_inbox
        core_inbox
      }

      it '#status' do
        expect(inbox.status).to eq(:detached)
      end
    end

    context 'and entry criteria' do

      let(:inbox) {
        create :entry_checkpoint, inbox: core_inbox
        core_inbox
      }

      it '#status' do
        expect(inbox.status).to eq(:detached)
      end
    end

    context 'and exit criteria' do

      let(:inbox) {
        create :exit_checkpoint, inbox: core_inbox
        core_inbox
      }

      it '#status' do
        expect(inbox.status).to eq(:detached)
      end
    end

    context 'and no criteria' do

      let(:inbox) {
        core_inbox
      }

      it '#status' do
        expect(inbox.status).to eq(:deprecated)
      end

    end

  end

  let(:expected_json) {
    {
      timestamp: "20160718120000",
      inbox_app_inbox:'v1',
      inbox:{
        name:'Example Inbox',
        checkpoints: [
          {
            direction: 'entry',
            subject_role: 'package',
            event_type: 'delivery',
            metadata: { 'delivery_method' => { eq: 'courier' }},
            primary_details: ['deliver_method'],
            secondary_details: ['shipping_cost'],
            primary_associations: ['sender'],
            secondary_associations: ['recipient']
          },
          {
            direction: 'exit',
            subject_role: 'package',
            event_type: 'delivery',
            metadata: { 'delivery_method' => { eq: 'courier' }},
            primary_details: ['deliver_method'],
            secondary_details: ['shipping_cost'],
            primary_associations: ['sender'],
            secondary_associations: ['recipient']
          }
        ]
      }
    }.to_json
  }

  context 'a fully configured inbox' do

    let(:inbox) { create :full_inbox, name: 'Example Inbox' }

    it 'can be fancy' do
      travel_to(DateTime.new(2016,07,18,12,00)) do
        expect(InboxSerializer.new(inbox).serialize).to eq(expected_json)
      end
    end
  end

  let(:deserialized_json) { InboxSerializer.deserialize(expected_json) }

  it '::deserialize' do
    expect(deserialized_json).to be_a(Inbox)
    expect(deserialized_json.name).to eq('Example Inbox')
    expect(deserialized_json.checkpoints.count).to eq(2)
    expect(deserialized_json.checkpoints.first.direction).to eq('entry')
    expect(deserialized_json.checkpoints.first.conditions.sort).to eq({
      metadata: { 'delivery_method' => { 'eq' => 'courier' }},
      primary_details: ['deliver_method'],
      secondary_details: ['shipping_cost'],
      primary_associations: ['sender'],
      secondary_associations: ['recipient']
    }.sort)
  end


end
