require 'spec_helper'

describe "user_location_tagged_users/new" do
  before(:each) do
    assign(:user_location_tagged_user, stub_model(UserLocationTaggedUser).as_new_record)
  end

  it "renders new user_location_tagged_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_location_tagged_users_path, "post" do
    end
  end
end
