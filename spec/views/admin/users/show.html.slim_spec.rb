require 'spec_helper'

describe "admin/users/show" do
  before(:each) do
    @admin_user = assign(:admin_user, stub_model(Admin::User,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    rendered.should match(/Reset Password Token/)
    rendered.should match(/1/)
    rendered.should match(/Current Sign In Ip/)
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Gender/)
    rendered.should match(/2/)
    rendered.should match(/Locale/)
    rendered.should match(/Picture Url/)
    rendered.should match(/Link/)
    rendered.should match(/MyText/)
    rendered.should match(/3/)
    rendered.should match(/Nickname/)
    rendered.should match(/Slug/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/4/)
    rendered.should match(/MyText/)
    rendered.should match(/Authentication Token/)
    rendered.should match(/Phone/)
    rendered.should match(/Confirmation Token/)
    rendered.should match(/Unconfirmed Email/)
    rendered.should match(/5/)
  end
end
