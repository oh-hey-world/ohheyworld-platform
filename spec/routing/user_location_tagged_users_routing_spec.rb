require "spec_helper"

describe UserLocationTaggedUsersController do
  describe "routing" do

    it "routes to #index" do
      get("/user_location_tagged_users").should route_to("user_location_tagged_users#index")
    end

    it "routes to #new" do
      get("/user_location_tagged_users/new").should route_to("user_location_tagged_users#new")
    end

    it "routes to #show" do
      get("/user_location_tagged_users/1").should route_to("user_location_tagged_users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_location_tagged_users/1/edit").should route_to("user_location_tagged_users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_location_tagged_users").should route_to("user_location_tagged_users#create")
    end

    it "routes to #update" do
      put("/user_location_tagged_users/1").should route_to("user_location_tagged_users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_location_tagged_users/1").should route_to("user_location_tagged_users#destroy", :id => "1")
    end

  end
end
