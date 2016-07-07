require 'rails_helper'

RSpec.describe Checkpoint, type: :model do

  it "requires an event_type" do
    @checkpoint = build :checkpoint, event_type: nil
    expect(@checkpoint).to_not be_valid
    expect(@checkpoint.errors[:event_type]).to include("can't be blank")
  end

  it "requires a subject_role" do
    @checkpoint = build :checkpoint, subject_role: nil
    expect(@checkpoint).to_not be_valid
    expect(@checkpoint.errors[:subject_role]).to include("can't be blank")
  end

  it "requires a direction" do
    @checkpoint = build :checkpoint, direction: nil
    expect(@checkpoint).to_not be_valid
    expect(@checkpoint.errors[:direction]).to include("can't be blank")
  end

  it "direction must be entry or exit" do
    @checkpoint = build :checkpoint, direction: 'shake_it_all_about'
    expect(@checkpoint).to_not be_valid
    expect(@checkpoint.errors[:direction]).to include("is not included in the list")
  end

  it "validates the format of conditions" do
    @checkpoint = build :checkpoint, conditions: {:invalid_key=>[]}
    expect(@checkpoint).to_not be_valid
    expect(@checkpoint.errors[:conditions]).to include("has an unrecognised key")
  end

  context 'when the context is valid' do

    let(:checkpoint) { build :checkpoint, event_type: 'valid', conditions: {metadata:{'test'=> {eq: 'match'},'other'=> {eq: 'match'}}} }

    context 'and the message matches' do
      let(:message) { build :message, event_type: 'valid', metadata: {'test'=> 'match','other'=> 'match'} }
      it('#check') { expect(checkpoint.check(message)).to be true }
    end

    context 'and the message event type is wrong' do
      let(:message) { build :message, event_type: 'invalid', metadata: {'test'=> 'match','other'=> 'match'} }
      it('#check') { expect(checkpoint.check(message)).to be false }
    end

    context 'and the message metadata is wrong' do
      let(:message) { build :message, event_type: 'valid', metadata: {'test'=> 'miss','other'=> 'match'} }
      it('#check') { expect(checkpoint.check(message)).to be false }
    end

    context 'and the message metadata is a mix of wrong and right' do
      let(:message) { build :message, event_type: 'valid', metadata: {'test'=>'match','other'=> 'miss'} }
      it('#check') { expect(checkpoint.check(message)).to be false }
    end

  end

  context 'when a message is processed' do

    let(:checkpoint) { build :checkpoint, direction: direction, subject_role: 'tracked', conditions: {
      primary_details: ['Key A'],
      secondary_details: ['Key B'],
      primary_associations: ['untracked'],
      secondary_associations: []
    }}


    let(:direction) { 'entry' }

    let(:tracked_subject) { build :subject, uuid: SecureRandom.uuid, friendly_name: 'colin', role_type: 'tracked' }
    let(:untracked_subject) { build :subject, role_type: 'untracked', friendly_name: 'untracked_name' }
    let(:message) { build :message, event_type: 'valid', subjects: [tracked_subject,untracked_subject], metadata: {
      'Key A' => 'Value A', 'Key B' => 'Value B', 'Key C' => 'Value C'
    } }

    context 'when direction is entry' do

      let(:created_item) { checkpoint.inbox.items.first }

      it '#process adds an item ' do
        checkpoint.process(message)
        expect(checkpoint.inbox.items.count).to eq(1)
        expect(created_item.uuid).to eq(tracked_subject.uuid)
        expect(created_item.name).to eq(tracked_subject.friendly_name)
      end

      it '#process pulls out the right information' do
        checkpoint.process(message)
        expect(created_item.details).to eq({
        :primary_details => {'Key A'=>'Value A'},
        :secondary_details=>{'Key B'=>'Value B'},
        :primary_associations => {'untracked'=>['untracked_name']},
        :secondary_associations => {}
      })
      end

    end

    context 'when direction is exit' do

      let(:direction) { 'exit' }
      let(:existing_item) { create :item, inbox: checkpoint.inbox, uuid: existing_uuid }

      context 'and you have a matching message' do

        let(:existing_uuid) { tracked_subject.uuid }

        it '#process removes it' do#
          existing_item
          checkpoint.process(message)
          expect(checkpoint.inbox.items.count).to eq(1)
          expect(checkpoint.inbox.items.pending.count).to eq(0)
        end
      end
      context 'and you have no matching message' do

        let(:existing_uuid) { SecureRandom.uuid }

        it '#process does nothing' do
          existing_item
          checkpoint.process(message)
          expect(checkpoint.inbox.items.count).to eq(1)
          expect(checkpoint.inbox.items.pending.count).to eq(1)
        end
      end
    end
  end

end
