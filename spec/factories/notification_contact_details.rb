# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_contact_detail do
    name "MyString"
    value "MyString"
    type ""
    user_id 1
  end
end
