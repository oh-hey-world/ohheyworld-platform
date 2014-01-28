# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_user, :class => 'Admin::User' do
    email "MyString"
    reset_password_token "MyString"
    reset_password_sent_at "2013-04-08 13:49:38"
    sign_in_count 1
    current_sign_in_at "2013-04-08 13:49:38"
    last_sign_in_at "2013-04-08 13:49:38"
    current_sign_in_ip "MyString"
    created_at "2013-04-08 13:49:38"
    updated_at "2013-04-08 13:49:38"
    first_name "MyString"
    last_name "MyString"
    gender "MyString"
    timezone 1
    locale "MyString"
    picture_url "MyString"
    link "MyString"
    blurb "MyText"
    home_town_location_id 1
    nickname "MyString"
    slug "MyString"
    agrees_to_terms false
    completed_first_checkin false
    import_job_id 1
    import_job_finished_at "2013-04-08 13:49:38"
    send_overrides "MyText"
    authentication_token "MyString"
    phone "MyString"
    confirmation_token "MyString"
    confirmed_at "2013-04-08 13:49:38"
    confirmation_sent_at "2013-04-08 13:49:38"
    unconfirmed_email "MyString"
    phone_country_code_id 1
  end
end
