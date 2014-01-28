require 'spec_helper'

describe "user_cities/edit" do
  before(:each) do
    @user_city = assign(:user_city, stub_model(UserCity,
      :user_id => 1,
      :city_id => 1
    ))
  end

  it "renders the edit user_city form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_cities_path(@user_city), :method => "post" do
      assert_select "input#user_city_user_id", :name => "user_city[user_id]"
      assert_select "input#user_city_city_id", :name => "user_city[city_id]"
    end
  end
end
