class Teams::InboxesController < ApplicationController

  before_action :set_team
  before_action :set_inbox, only: [:show,:delete,:update,:destroy]

  DEFAULT_STATE = 'pending'

  # GET /teams
  # GET /teams.json
  def index
    @active_inbox = @team.inboxes.first
    @active_items = @active_inbox ? @active_inbox.items.which_are(state_param) : []
    render 'teams/show'
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @active_items = @active_inbox.items.which_are(state_param)
    render 'teams/show'
  end

  # GET /teams/new
  def new

  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create

  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update

  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy

  end

  private

  def set_team
    @team = Team.find_by!(key:params[:team_key])
  end

  def set_inbox
    @inbox = @active_inbox = Inbox.find_by!(key:params[:key])
  end

  def state_param
    params[:state]||DEFAULT_STATE
  end

end
