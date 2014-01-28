require 'spec_helper'

describe "user_cities/new" do
  before(:each) do
    assign(:user_city, stub_model(UserCity,
      :user_id => 1,
      :city_id => 1
    ).as_new_record)
  end

  it "renders new user_city form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_cities_path, :method => "post" do
      assert_select "input#user_city_user_id", :name => "user_city[user_id]"
      assert_select "input#user_city_city_id", :name => "user_city[city_id]"
    end
  end
end
