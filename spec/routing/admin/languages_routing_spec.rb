require "spec_helper"

describe Admin::LanguagesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/languages").should route_to("admin/languages#index")
    end

    it "routes to #new" do
      get("/admin/languages/new").should route_to("admin/languages#new")
    end

    it "routes to #show" do
      get("/admin/languages/1").should route_to("admin/languages#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/languages/1/edit").should route_to("admin/languages#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/languages").should route_to("admin/languages#create")
    end

    it "routes to #update" do
      put("/admin/languages/1").should route_to("admin/languages#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/languages/1").should route_to("admin/languages#destroy", :id => "1")
    end

  end
end
