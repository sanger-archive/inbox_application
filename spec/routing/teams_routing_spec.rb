require "rails_helper"

RSpec.describe TeamsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/teams").to route_to("teams#index")
    end

    it "routes to #new" do
      expect(:get => "/teams/new").to route_to("teams#new")
    end

    it "routes to #show" do
      expect(:get => "/teams/team-a").to route_to("teams#show", :key => "team-a")
    end

    it "routes to #edit" do
      expect(:get => "/teams/team-a/edit").to route_to("teams#edit", :key => "team-a")
    end

    it "routes to #create" do
      expect(:post => "/teams").to route_to("teams#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/teams/team-a").to route_to("teams#update", :key => "team-a")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/teams/team-a").to route_to("teams#update", :key => "team-a")
    end

    it "routes to #destroy" do
      expect(:delete => "/teams/team-a").to route_to("teams#destroy", :key => "team-a")
    end

  end
end
