class Teams::InboxesController < ApplicationController

  before_action :set_team
  before_action :set_inbox, only: [:show,:delete,:update,:destroy]

  DEFAULT_STATE = 'pending'

  # GET /teams
  # GET /teams.json
  def index
    @active_inbox = @team.inboxes.first
    @active_items = @active_inbox ? @active_inbox.items.which_are(state_param) : []
    @state = state_param
    @batchable = @state == 'pending'
    render 'teams/show'
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @active_items = @active_inbox.items.which_are(state_param)
    @state = state_param
    @batchable = @state == 'pending'
    render 'teams/show'
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    # This is a has_many through, the inbox itself is not destroyed
    # only the team_inbox association. This is the intended behaviour
    @team.inboxes.destroy(@inbox)
    redirect_to @team
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
