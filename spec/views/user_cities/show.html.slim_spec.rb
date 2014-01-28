require 'spec_helper'

describe "user_cities/show" do
  before(:each) do
    @user_city = assign(:user_city, stub_model(UserCity,
      :user_id => 1,
      :city_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
