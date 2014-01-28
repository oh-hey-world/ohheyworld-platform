require 'spec_helper'

describe "admin/users/index" do
  before(:each) do
    assign(:admin_users, [
      stub_model(Admin::User,
        :email => "Email",
        :reset_password_token => "Reset Password Token",
        :sign_in_count => 1,
        :current_sign_in_ip => "Current Sign In Ip",
        :first_name => "First Name",
        :last_name => "Last Name",
        :gender => "Gender",
        :timezone => 2,
        :locale => "Locale",
        :picture_url => "Picture Url",
        :link => "Link",
        :blurb => "MyText",
        :home_town_location_id => 3,
        :nickname => "Nickname",
        :slug => "Slug",
        :agrees_to_terms => false,
        :completed_first_checkin => false,
        :import_job_id => 4,
        :send_overrides => "MyText",
        :authentication_token => "Authentication Token",
        :phone => "Phone",
        :confirmation_token => "Confirmation Token",
        :unconfirmed_email => "Unconfirmed Email",
        :phone_country_code_id => 5
      ),
      stub_model(Admin::User,
        :email => "Email",
        :reset_password_token => "Reset Password Token",
        :sign_in_count => 1,
        :current_sign_in_ip => "Current Sign In Ip",
        :first_name => "First Name",
        :last_name => "Last Name",
        :gender => "Gender",
        :timezone => 2,
        :locale => "Locale",
        :picture_url => "Picture Url",
        :link => "Link",
        :blurb => "MyText",
        :home_town_location_id => 3,
        :nickname => "Nickname",
        :slug => "Slug",
        :agrees_to_terms => false,
        :completed_first_checkin => false,
        :import_job_id => 4,
        :send_overrides => "MyText",
        :authentication_token => "Authentication Token",
        :phone => "Phone",
        :confirmation_token => "Confirmation Token",
        :unconfirmed_email => "Unconfirmed Email",
        :phone_country_code_id => 5
      )
    ])
  end

  it "renders a list of admin/users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Reset Password Token".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Current Sign In Ip".to_s, :count => 2
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Locale".to_s, :count => 2
    assert_select "tr>td", :text => "Picture Url".to_s, :count => 2
    assert_select "tr>td", :text => "Link".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Nickname".to_s, :count => 2
    assert_select "tr>td", :text => "Slug".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Authentication Token".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Confirmation Token".to_s, :count => 2
    assert_select "tr>td", :text => "Unconfirmed Email".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
