require 'spec_helper'

describe "UserLocationTaggedUsers" do
  describe "GET /user_location_tagged_users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_location_tagged_users_path
      response.status.should be(200)
    end
  end
end
