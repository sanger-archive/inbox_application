require "rails_helper"

RSpec.describe InboxesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/inboxes").to route_to("inboxes#index")
    end

    it "routes to #new" do
      expect(:get => "/inboxes/new").to route_to("inboxes#new")
    end

    it "routes to #show" do
      expect(:get => "/inboxes/1").to route_to("inboxes#show", :key => "1")
    end

    it "routes to #edit" do
      expect(:get => "/inboxes/1/edit").to route_to("inboxes#edit", :key => "1")
    end

    it "routes to #create" do
      expect(:post => "/inboxes").to route_to("inboxes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/inboxes/1").to route_to("inboxes#update", :key => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/inboxes/1").to route_to("inboxes#update", :key => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/inboxes/1").to route_to("inboxes#destroy", :key => "1")
    end

  end
end
