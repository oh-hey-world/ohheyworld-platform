# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :provider_friend do
    provider_name "MyString"
    user_name "MyString"
    uid "MyString"
    picture_url "MyString"
    location_city "MyString"
    location_state "MyString"
  end
end
