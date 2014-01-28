require 'spec_helper'

describe "user_city_tips/index" do
  before(:each) do
    assign(:user_city_tips, [
      stub_model(UserCityTip,
        :user_id => 1,
        :city_id => 2,
        :tip => "MyText",
        :rating => "9.99"
      ),
      stub_model(UserCityTip,
        :user_id => 1,
        :city_id => 2,
        :tip => "MyText",
        :rating => "9.99"
      )
    ])
  end

  it "renders a list of user_city_tips" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
