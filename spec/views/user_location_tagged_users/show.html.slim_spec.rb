require 'spec_helper'

describe "user_location_tagged_users/show" do
  before(:each) do
    @user_location_tagged_user = assign(:user_location_tagged_user, stub_model(UserLocationTaggedUser))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
