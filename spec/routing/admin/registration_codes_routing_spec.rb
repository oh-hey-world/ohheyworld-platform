require "spec_helper"

describe Admin::RegistrationCodesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/registration_codes").should route_to("admin/registration_codes#index")
    end

    it "routes to #new" do
      get("/admin/registration_codes/new").should route_to("admin/registration_codes#new")
    end

    it "routes to #show" do
      get("/admin/registration_codes/1").should route_to("admin/registration_codes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/registration_codes/1/edit").should route_to("admin/registration_codes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/registration_codes").should route_to("admin/registration_codes#create")
    end

    it "routes to #update" do
      put("/admin/registration_codes/1").should route_to("admin/registration_codes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/registration_codes/1").should route_to("admin/registration_codes#destroy", :id => "1")
    end

  end
end
