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
      get :index, {:team_key => team.to_param}, valid_session
      expect(assigns(:team)).to eq(team)
    end

    it "assigns the first inbox as @active_inbox" do
      team = create :team
      inbox = create :inbox
      create :team_inbox, team: team, inbox: inbox
      get :index, {:team_key => team.to_param}, valid_session
      expect(assigns(:active_inbox)).to eq(inbox)
    end
  end

  describe "GET #show" do
    it "assigns the requested team as @team" do
      team = create :team
      inbox = create :inbox
      create :team_inbox, team: team, inbox: inbox
      get :show, {:team_key => team.to_param, :key => inbox.key }, valid_session
      expect(assigns(:team)).to eq(team)
    end

    it "assigns the selected inbox as @active_inbox" do
      team = create :team
      inbox = create :inbox
      inbox2 = create :inbox
      create :team_inbox, team: team, inbox: inbox, order: 0
      create :team_inbox, team: team, inbox: inbox2, order: 1
      get :show, {:team_key => team.to_param, :key => inbox2.key}, valid_session
      expect(assigns(:active_inbox)).to eq(inbox2)
    end
  end

  # describe "GET #new" do
  #   it "assigns a new team as @team" do
  #     get :new, {}, valid_session
  #     expect(assigns(:team)).to be_a_new(Team)
  #   end
  # end

  # describe "GET #edit" do
  #   it "assigns the requested team as @team" do
  #     team = Team.create! valid_attributes
  #     get :edit, {:key => team.to_param}, valid_session
  #     expect(assigns(:team)).to eq(team)
  #   end
  # end

  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Team" do
  #       expect {
  #         post :create, {:team => valid_attributes}, valid_session
  #       }.to change(Team, :count).by(1)
  #     end

  #     it "assigns a newly created team as @team" do
  #       post :create, {:team => valid_attributes}, valid_session
  #       expect(assigns(:team)).to be_a(Team)
  #       expect(assigns(:team)).to be_persisted
  #     end

  #     it "redirects to the created team" do
  #       post :create, {:team => valid_attributes}, valid_session
  #       expect(response).to redirect_to(Team.last)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved team as @team" do
  #       post :create, {:team => invalid_attributes}, valid_session
  #       expect(assigns(:team)).to be_a_new(Team)
  #     end

  #     it "re-renders the 'new' template" do
  #       post :create, {:team => invalid_attributes}, valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end

  # describe "PUT #update" do
  #   context "with valid params" do

  #     let(:new_attributes) {
  #       {name:'My Happier Team'}
  #     }

  #     it "updates the requested team" do
  #       team = Team.create! valid_attributes
  #       put :update, {:key => team.to_param, :team => new_attributes}, valid_session
  #       team.reload
  #       expect(team.name).to eq('My Happier Team')
  #       expect(team.key).to eq('my-happier-team')
  #     end

  #     it "assigns the requested team as @team" do
  #       team = Team.create! valid_attributes
  #       put :update, {:key => team.to_param, :team => valid_attributes}, valid_session
  #       expect(assigns(:team)).to eq(team)
  #     end

  #     it "redirects to the team" do
  #       team = Team.create! valid_attributes
  #       put :update, {:key => team.to_param, :team => valid_attributes}, valid_session
  #       expect(response).to redirect_to(team)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns the team as @team" do
  #       team = Team.create! valid_attributes
  #       put :update, {:key => team.to_param, :team => invalid_attributes}, valid_session
  #       expect(assigns(:team)).to eq(team)
  #     end

  #     it "re-renders the 'edit' template" do
  #       team = Team.create! valid_attributes
  #       put :update, {:key => team.to_param, :team => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested team" do
  #     team = Team.create! valid_attributes
  #     expect {
  #       delete :destroy, {:key => team.to_param}, valid_session
  #     }.to change(Team, :count).by(-1)
  #   end

  #   it "redirects to the teams list" do
  #     team = Team.create! valid_attributes
  #     delete :destroy, {:key => team.to_param}, valid_session
  #     expect(response).to redirect_to(teams_url)
  #   end
  # end

end
