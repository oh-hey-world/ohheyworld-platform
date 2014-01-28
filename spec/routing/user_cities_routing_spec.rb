require "spec_helper"

describe UserCitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/user_cities").should route_to("user_cities#index")
    end

    it "routes to #new" do
      get("/user_cities/new").should route_to("user_cities#new")
    end

    it "routes to #show" do
      get("/user_cities/1").should route_to("user_cities#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_cities/1/edit").should route_to("user_cities#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_cities").should route_to("user_cities#create")
    end

    it "routes to #update" do
      put("/user_cities/1").should route_to("user_cities#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_cities/1").should route_to("user_cities#destroy", :id => "1")
    end

  end
end
