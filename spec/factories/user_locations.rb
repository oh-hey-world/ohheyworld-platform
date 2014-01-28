# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_location do
    user_id 1
    latitude 1.5
    longitude 1.5
    address "MyString"
    city "MyString"
    state "MyString"
    state_code "MyString"
    postal_code "MyString"
    country "MyString"
    country_code "MyString"
  end
end
