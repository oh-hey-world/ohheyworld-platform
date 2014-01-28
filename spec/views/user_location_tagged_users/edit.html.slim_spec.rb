require 'spec_helper'

describe "user_location_tagged_users/edit" do
  before(:each) do
    @user_location_tagged_user = assign(:user_location_tagged_user, stub_model(UserLocationTaggedUser))
  end

  it "renders the edit user_location_tagged_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_location_tagged_user_path(@user_location_tagged_user), "post" do
    end
  end
end
