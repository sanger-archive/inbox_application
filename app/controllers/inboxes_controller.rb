class InboxesController < ApplicationController
  before_action :set_inbox, only: [:show, :edit, :update, :destroy]
  before_action :set_team, only: :new

  # GET /inboxes
  # GET /inboxes.json
  def index
    @inboxes = Inbox.alphabetical
  end

  # GET /inboxes/1
  # GET /inboxes/1.json
  def show
    respond_to do |format|
      format.html { render :show }
      format.json do
        headers['Content-Disposition'] = "attachment; filename=\"#{@inbox.timestamped_key}.json\"" if params[:download]
        render :json => @inbox.serialize, :content_type => 'application/json'
      end
    end
  end

  # GET /inboxes/new
  def new
    @inbox = Inbox.new
  end

  # GET /inboxes/1/edit
  def edit
  end

  # POST /inboxes
  # POST /inboxes.json
  def create
    @inbox = Inbox.new(inbox_params)

    if params[:inbox][:configuration]
      json_payload = params[:inbox][:configuration].read
      InboxSerializer.new(@inbox).from_json(json_payload)
      # If a name is provided, use that, rather than the one in the file.
      @inbox.name = inbox_params[:name] unless inbox_params[:name].blank?
    end

    respond_to do |format|
      if @inbox.save
        format.html { redirect_to @inbox, notice: 'Inbox was successfully created.' }
        format.json { render :show, status: :created, location: @inbox }
      else
        format.html { render :new }
        format.json { render json: @inbox.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inboxes/1
  # PATCH/PUT /inboxes/1.json
  def update

    if params[:inbox][:configuration]
      json_payload = params[:inbox][:configuration].read
      InboxSerializer.new(@inbox).from_json(json_payload)
    end

    respond_to do |format|
      if @inbox.update(inbox_params)
        format.html { redirect_to @inbox, notice: 'Inbox was successfully updated.' }
        format.json { render :show, status: :ok, location: @inbox }
      else
        format.html { render :edit }
        format.json { render json: @inbox.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inboxes/1
  # DELETE /inboxes/1.json
  def destroy
    @inbox.deactivate!
    respond_to do |format|
      format.html { redirect_to @inbox, notice: 'Inbox was successfully deactivated.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inbox
      @inbox = Inbox.find_by!(key:params[:key])
    end

    def set_team
      @team = Team.find_by(key:params[:team_key])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def inbox_params
      params.require(:inbox).permit(:name)
    end
end
