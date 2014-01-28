# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_provider do
    user_id 1
    provider "MyString"
    uid "MyString"
    first_name "MyString"
    last_name "MyString"
    gender "MyString"
    timezone 1
    locale "MyString"
    link "MyString"
    hometown "MyString"
    picture_url "MyString"
    provider_token "MyString"
    provider_token_timeout 1
  end
end
