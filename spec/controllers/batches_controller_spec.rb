require 'rails_helper'
require './spec/support/mock_user_lookup'

RSpec.describe BatchesController, type: :controller do

  let(:included_item) { create :item }
  let(:unincluded_item) { create :item }

  let(:valid_attributes) {
    {"items"=>{
      included_item.uuid => "1",
      unincluded_item.uuid => "0"
    }, "user_swipecard"=>"test"}
  }

  let(:invalid_attributes) {{"user_swipecard"=>nil,"items"=>{}}}
  let(:valid_session) {}

  before(:each) do
    @original = User.external_service
    mul = MockUserLookup.new({uuid:SecureRandom.uuid,login:'ab1'},'test')
    User.external_service = mul
  end

  after(:each) do
    User.external_service= @original
  end

  describe "post #create" do
    it "creates a new batch" do
      expect {
        post :create, params: { batch: valid_attributes }, session: valid_session
      }.to change(Batch, :count).by(1)
    end

    it "redirects to the batch page" do
      post :create, params: {:batch => valid_attributes}, session: valid_session
      expect(assigns(:batch)).to be_a(Batch)
      expect(response).to redirect_to(assigns(:batch))
    end

    it "puts only included items in the batch" do
      post :create, params: {batch: valid_attributes }, session: valid_session
      expect(assigns(:batch).items).to include(included_item)
      expect(assigns(:batch).items).to_not include(unincluded_item)
    end

    it "redirects back if options are invalid" do
      inbox = create :inbox
      request.env["HTTP_REFERER"] = inbox_path(inbox)
      expect {
        post :create, params: { batch: invalid_attributes }, session: valid_session
        expect(response).to redirect_to(inbox)
      }.to change(Batch, :count).by(0)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      batch = create :batch
      get :show, params: { id: batch.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:batch)).to eq(batch)
    end
  end

  describe "GET #destroy" do
    it "destroys the batch and redirects to the inbox" do
      batch = create :batch
      inbox = create :inbox
      create :item, batch: batch, inbox: inbox
      get :destroy, params: { id: batch.id }
      expect(response).to redirect_to(inbox)
      # Can't use be_destroyed here as we're looking at the wrong instance of batch
      expect(Batch.find_by(id:batch.id)).to be_nil
    end
  end

end
