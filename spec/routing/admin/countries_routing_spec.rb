require "spec_helper"

describe Admin::CountriesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/countries").should route_to("admin/countries#index")
    end

    it "routes to #new" do
      get("/admin/countries/new").should route_to("admin/countries#new")
    end

    it "routes to #show" do
      get("/admin/countries/1").should route_to("admin/countries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/countries/1/edit").should route_to("admin/countries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/countries").should route_to("admin/countries#create")
    end

    it "routes to #update" do
      put("/admin/countries/1").should route_to("admin/countries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/countries/1").should route_to("admin/countries#destroy", :id => "1")
    end

  end
end
