require "spec_helper"

describe BetaAccessRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/beta_access_requests").should route_to("beta_access_requests#index")
    end

    it "routes to #new" do
      get("/beta_access_requests/new").should route_to("beta_access_requests#new")
    end

    it "routes to #show" do
      get("/beta_access_requests/1").should route_to("beta_access_requests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/beta_access_requests/1/edit").should route_to("beta_access_requests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/beta_access_requests").should route_to("beta_access_requests#create")
    end

    it "routes to #update" do
      put("/beta_access_requests/1").should route_to("beta_access_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/beta_access_requests/1").should route_to("beta_access_requests#destroy", :id => "1")
    end

  end
end
