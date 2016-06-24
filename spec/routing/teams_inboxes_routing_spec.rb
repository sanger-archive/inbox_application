require "rails_helper"

RSpec.describe Teams::InboxesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/teams/team-a/inboxes").to route_to("teams/inboxes#index", team_key:'team-a')
    end

    it "routes to #new" do
      expect(:get => "/teams/team-a/inboxes/new").to route_to("teams/inboxes#new", team_key:'team-a')
    end

    it "routes to #show" do
      expect(:get => "/teams/team-a/inboxes/inbox-a").to route_to("teams/inboxes#show", team_key:'team-a', :key => "inbox-a")
    end

    it "routes to #create" do
      expect(:post => "/teams/team-a/inboxes").to route_to("teams/inboxes#create", team_key:'team-a')
    end

    it "routes to #update via PUT" do
      expect(:put => "/teams/team-a/inboxes/inbox-a").to route_to("teams/inboxes#update", team_key:'team-a', :key => "inbox-a")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/teams/team-a/inboxes/inbox-a").to route_to("teams/inboxes#update", team_key:'team-a', :key => "inbox-a")
    end

    it "routes to #destroy" do
      expect(:delete => "/teams/team-a/inboxes/inbox-a").to route_to("teams/inboxes#destroy", team_key:'team-a', :key => "inbox-a")
    end

  end
end
