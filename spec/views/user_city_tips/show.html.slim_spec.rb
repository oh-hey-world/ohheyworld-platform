require 'spec_helper'

describe "user_city_tips/show" do
  before(:each) do
    @user_city_tip = assign(:user_city_tip, stub_model(UserCityTip,
      :user_id => 1,
      :city_id => 2,
      :tip => "MyText",
      :rating => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/MyText/)
    rendered.should match(/9.99/)
  end
end
