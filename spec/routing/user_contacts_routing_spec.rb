require "spec_helper"

describe UserContactsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_contacts").should route_to("user_contacts#index")
    end

    it "routes to #new" do
      get("/user_contacts/new").should route_to("user_contacts#new")
    end

    it "routes to #show" do
      get("/user_contacts/1").should route_to("user_contacts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_contacts/1/edit").should route_to("user_contacts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_contacts").should route_to("user_contacts#create")
    end

    it "routes to #update" do
      put("/user_contacts/1").should route_to("user_contacts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_contacts/1").should route_to("user_contacts#destroy", :id => "1")
    end

  end
end
