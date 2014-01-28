require 'spec_helper'

describe "user_city_tips/new" do
  before(:each) do
    assign(:user_city_tip, stub_model(UserCityTip,
      :user_id => 1,
      :city_id => 1,
      :tip => "MyText",
      :rating => "9.99"
    ).as_new_record)
  end

  it "renders new user_city_tip form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_city_tips_path, :method => "post" do
      assert_select "input#user_city_tip_user_id", :name => "user_city_tip[user_id]"
      assert_select "input#user_city_tip_city_id", :name => "user_city_tip[city_id]"
      assert_select "textarea#user_city_tip_tip", :name => "user_city_tip[tip]"
      assert_select "input#user_city_tip_rating", :name => "user_city_tip[rating]"
    end
  end
end
