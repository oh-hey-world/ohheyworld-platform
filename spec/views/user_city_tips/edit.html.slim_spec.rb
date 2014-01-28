require 'spec_helper'

describe "user_city_tips/edit" do
  before(:each) do
    @user_city_tip = assign(:user_city_tip, stub_model(UserCityTip,
      :user_id => 1,
      :city_id => 1,
      :tip => "MyText",
      :rating => "9.99"
    ))
  end

  it "renders the edit user_city_tip form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_city_tips_path(@user_city_tip), :method => "post" do
      assert_select "input#user_city_tip_user_id", :name => "user_city_tip[user_id]"
      assert_select "input#user_city_tip_city_id", :name => "user_city_tip[city_id]"
      assert_select "textarea#user_city_tip_tip", :name => "user_city_tip[tip]"
      assert_select "input#user_city_tip_rating", :name => "user_city_tip[rating]"
    end
  end
end
