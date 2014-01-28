require "spec_helper"

describe Admin::UsersController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/users").should route_to("admin/users#index")
    end

    it "routes to #new" do
      get("/admin/users/new").should route_to("admin/users#new")
    end

    it "routes to #show" do
      get("/admin/users/1").should route_to("admin/users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/users/1/edit").should route_to("admin/users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/users").should route_to("admin/users#create")
    end

    it "routes to #update" do
      put("/admin/users/1").should route_to("admin/users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/users/1").should route_to("admin/users#destroy", :id => "1")
    end

  end
end
