require "spec_helper"

describe UserCityTipsController do
  describe "routing" do

    it "routes to #index" do
      get("/user_city_tips").should route_to("user_city_tips#index")
    end

    it "routes to #new" do
      get("/user_city_tips/new").should route_to("user_city_tips#new")
    end

    it "routes to #show" do
      get("/user_city_tips/1").should route_to("user_city_tips#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_city_tips/1/edit").should route_to("user_city_tips#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_city_tips").should route_to("user_city_tips#create")
    end

    it "routes to #update" do
      put("/user_city_tips/1").should route_to("user_city_tips#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_city_tips/1").should route_to("user_city_tips#destroy", :id => "1")
    end

  end
end
