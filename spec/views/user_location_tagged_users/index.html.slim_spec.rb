require 'spec_helper'

describe "user_location_tagged_users/index" do
  before(:each) do
    assign(:user_location_tagged_users, [
      stub_model(UserLocationTaggedUser),
      stub_model(UserLocationTaggedUser)
    ])
  end

  it "renders a list of user_location_tagged_users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
