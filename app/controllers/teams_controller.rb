class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

  DEFAULT_STATE = 'pending'

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.alphabetical
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @active_inbox = @team.inboxes.first
    @active_items = @active_inbox.present? ? @active_inbox.items.which_are(state_param) : []
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    @other_inboxes = Inbox.where(['id NOT IN (?)',@team.inboxes.map(&:id)])
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find_by!(key:params[:key])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # Note that we use custom team_inboxes_attributes assignment
    def team_params
      params.require(:team).permit(:name,{team_inboxes_attributes:[:key,:order]})
    end

    def state_param
      params[:state]||DEFAULT_STATE
    end
end
