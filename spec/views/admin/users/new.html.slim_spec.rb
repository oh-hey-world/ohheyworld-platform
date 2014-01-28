require 'spec_helper'

describe "admin/users/new" do
  before(:each) do
    assign(:admin_user, stub_model(Admin::User,
      :email => "MyString",
      :reset_password_token => "MyString",
      :sign_in_count => 1,
      :current_sign_in_ip => "MyString",
      :first_name => "MyString",
      :last_name => "MyString",
      :gender => "MyString",
      :timezone => 1,
      :locale => "MyString",
      :picture_url => "MyString",
      :link => "MyString",
      :blurb => "MyText",
      :home_town_location_id => 1,
      :nickname => "MyString",
      :slug => "MyString",
      :agrees_to_terms => false,
      :completed_first_checkin => false,
      :import_job_id => 1,
      :send_overrides => "MyText",
      :authentication_token => "MyString",
      :phone => "MyString",
      :confirmation_token => "MyString",
      :unconfirmed_email => "MyString",
      :phone_country_code_id => 1
    ).as_new_record)
  end

  it "renders new admin_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_users_path, "post" do
      assert_select "input#admin_user_email[name=?]", "admin_user[email]"
      assert_select "input#admin_user_reset_password_token[name=?]", "admin_user[reset_password_token]"
      assert_select "input#admin_user_sign_in_count[name=?]", "admin_user[sign_in_count]"
      assert_select "input#admin_user_current_sign_in_ip[name=?]", "admin_user[current_sign_in_ip]"
      assert_select "input#admin_user_first_name[name=?]", "admin_user[first_name]"
      assert_select "input#admin_user_last_name[name=?]", "admin_user[last_name]"
      assert_select "input#admin_user_gender[name=?]", "admin_user[gender]"
      assert_select "input#admin_user_timezone[name=?]", "admin_user[timezone]"
      assert_select "input#admin_user_locale[name=?]", "admin_user[locale]"
      assert_select "input#admin_user_picture_url[name=?]", "admin_user[picture_url]"
      assert_select "input#admin_user_link[name=?]", "admin_user[link]"
      assert_select "textarea#admin_user_blurb[name=?]", "admin_user[blurb]"
      assert_select "input#admin_user_home_town_location_id[name=?]", "admin_user[home_town_location_id]"
      assert_select "input#admin_user_nickname[name=?]", "admin_user[nickname]"
      assert_select "input#admin_user_slug[name=?]", "admin_user[slug]"
      assert_select "input#admin_user_agrees_to_terms[name=?]", "admin_user[agrees_to_terms]"
      assert_select "input#admin_user_completed_first_checkin[name=?]", "admin_user[completed_first_checkin]"
      assert_select "input#admin_user_import_job_id[name=?]", "admin_user[import_job_id]"
      assert_select "textarea#admin_user_send_overrides[name=?]", "admin_user[send_overrides]"
      assert_select "input#admin_user_authentication_token[name=?]", "admin_user[authentication_token]"
      assert_select "input#admin_user_phone[name=?]", "admin_user[phone]"
      assert_select "input#admin_user_confirmation_token[name=?]", "admin_user[confirmation_token]"
      assert_select "input#admin_user_unconfirmed_email[name=?]", "admin_user[unconfirmed_email]"
      assert_select "input#admin_user_phone_country_code_id[name=?]", "admin_user[phone_country_code_id]"
    end
  end
end
