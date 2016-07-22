require 'rails_helper'

RSpec.describe Teams::InboxesController, type: :controller do


  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TeamsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  # Behaves VERY similarly to get team
  # We could probably DRY this out
  describe "GET #index" do
    it "assigns the requested team as @team" do
      team = create :team
      get :index, params: {:team_key => team.to_param}, session: valid_session
      expect(assigns(:team)).to eq(team)
    end

    it "assigns the first inbox as @active_inbox" do
      team = create :team
      inbox = create :inbox
      create :team_inbox, team: team, inbox: inbox
      get :index, params: {:team_key => team.to_param}, session: valid_session
      expect(assigns(:active_inbox)).to eq(inbox)
      expect(assigns(:active_items)).to eq(inbox.items.pending)
    end
  end

  describe "GET #show" do
    it "assigns the requested team as @team" do
      team = create :team
      inbox = create :inbox
      create :team_inbox, team: team, inbox: inbox
      get :show, params: {:team_key => team.to_param, :key => inbox.key }, session: valid_session
      expect(assigns(:team)).to eq(team)
    end

    it "assigns the selected inbox as @active_inbox" do
      team = create :team
      inbox = create :inbox
      inbox2 = create :inbox
      pending_item = create :pending_item, inbox: inbox
      create :team_inbox, team: team, inbox: inbox, order: 0
      create :team_inbox, team: team, inbox: inbox2, order: 1
      get :show, params: {:team_key => team.to_param, :key => inbox2.key}, session: valid_session
      expect(assigns(:active_inbox)).to eq(inbox2)
      expect(assigns(:active_items)).to eq(inbox2.items.pending)
    end

    it "with a state parameter applies the expected filter" do
      team = create :team
      inbox = create :inbox
      batched_item = create :batched_item, inbox: inbox
      create :team_inbox, team: team, inbox: inbox, order: 0
      get :show, params: {:team_key => team.to_param, :key => inbox.key, :state=> 'batched'}, session: valid_session
      expect(assigns(:active_inbox)).to eq(inbox)
      expect(assigns(:active_items)).to eq(inbox.items.batched)
    end
  end

  describe "DELETE #destroy" do
    it "removes the inbox from the requested team" do

      team = create :team
      inbox = create :inbox
      create :team_inbox, team: team, inbox: inbox

      expect {
        delete :destroy, params: {:team_key => team.to_param, :key => inbox.key }, session: valid_session
      }.to change(TeamInbox, :count).by(-1)

      expect(team.inboxes).to_not include(inbox)

      expect(Inbox.find_by_key(inbox.key)).to_not be_nil
    end

    it "redirects to the team edit page" do

      team = create :team
      inbox = create :inbox
      create :team_inbox, team: team, inbox: inbox

      delete :destroy, params: {:team_key => team.to_param, :key => inbox.key }, session: valid_session
      expect(response).to redirect_to(team)
    end
  end

end
