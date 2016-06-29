require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Team. As you add validations to Team, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {name:'My Happy Team'}
  }

  let(:invalid_attributes) {
    {name:'###~'}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TeamsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  let(:team)  { create :team }
  let(:inbox) { create :inbox }

  describe "GET #index" do
    it "assigns all teams as @teams" do
      team = Team.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:teams)).to eq([team])
    end
  end

  describe "GET #show" do
    it "assigns the requested team as @team" do
      get :show, {:key => team.to_param}, valid_session
      expect(assigns(:team)).to eq(team)
    end

    it "assigns the first inbox as @active_inbox" do
      create :team_inbox, team: team, inbox: inbox
      get :show, {:key => team.to_param}, valid_session
      expect(assigns(:active_inbox)).to eq(inbox)
    end

    it "assigns the pending items to @active_items" do

    end

  end

  describe "GET #new" do
    it "assigns a new team as @team" do
      get :new, {}, valid_session
      expect(assigns(:team)).to be_a_new(Team)
    end
  end

  describe "GET #edit" do
    it "assigns the requested team as @team" do
      team = create :team_with_inbox
      inbox = create :inbox
      other_inbox = create :inbox
      create :team_inbox, team: team, inbox: inbox
      get :edit, {:key => team.to_param}, valid_session
      expect(assigns(:team)).to eq(team)
      expect(assigns(:other_inboxes)).to eq([other_inbox])
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Team" do
        expect {
          post :create, {:team => valid_attributes}, valid_session
        }.to change(Team, :count).by(1)
      end

      it "assigns a newly created team as @team" do
        post :create, {:team => valid_attributes}, valid_session
        expect(assigns(:team)).to be_a(Team)
        expect(assigns(:team)).to be_persisted
      end

      it "redirects to the created team" do
        post :create, {:team => valid_attributes}, valid_session
        expect(response).to redirect_to(Team.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved team as @team" do
        post :create, {:team => invalid_attributes}, valid_session
        expect(assigns(:team)).to be_a_new(Team)
      end

      it "re-renders the 'new' template" do
        post :create, {:team => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do

      let(:new_attributes) {
        {name:'My Happier Team'}
      }

      it "updates the requested team" do
        team = Team.create! valid_attributes
        put :update, {:key => team.to_param, :team => new_attributes}, valid_session
        team.reload
        expect(team.name).to eq('My Happier Team')
        expect(team.key).to eq('my-happier-team')
      end

      it "assigns the requested team as @team" do
        team = Team.create! valid_attributes
        put :update, {:key => team.to_param, :team => valid_attributes}, valid_session
        expect(assigns(:team)).to eq(team)
      end

      it "redirects to the team" do
        team = Team.create! valid_attributes
        put :update, {:key => team.to_param, :team => valid_attributes}, valid_session
        expect(response).to redirect_to(team)
      end

      it "can update inbox orders" do
        team = create :team_with_inbox, inbox_count: 2
        original_excluded = create :inbox
        original_first = team.inboxes.first
        original_second = team.inboxes.last
        team_inbox_parameters = {
          "0"=>{"key"=>original_first.key, "order"=>""},
          "1"=>{"key"=>original_second.key, "order"=>"1"},
          "2"=>{"key"=>original_excluded.key, "order"=>"0"}
        }
        put :update, {:key => team.to_param, :team => {:team_inboxes_attributes => team_inbox_parameters}}, valid_session
        team.reload
        expect(response).to redirect_to(team)
        expect(team.inboxes.first).to eq(original_excluded)
        expect(team.inboxes.last).to eq(original_second)
        expect(team.inboxes).to_not include(original_first)
      end
    end

    context "with invalid params" do
      it "assigns the team as @team" do
        team = Team.create! valid_attributes
        put :update, {:key => team.to_param, :team => invalid_attributes}, valid_session
        expect(assigns(:team)).to eq(team)
      end

      it "re-renders the 'edit' template" do
        team = Team.create! valid_attributes
        put :update, {:key => team.to_param, :team => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested team" do
      team = Team.create! valid_attributes
      expect {
        delete :destroy, {:key => team.to_param}, valid_session
      }.to change(Team, :count).by(-1)
    end

    it "redirects to the teams list" do
      team = Team.create! valid_attributes
      delete :destroy, {:key => team.to_param}, valid_session
      expect(response).to redirect_to(teams_url)
    end
  end

end
