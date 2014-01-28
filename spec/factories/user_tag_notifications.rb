# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_tag_notification do
    user_id 1
    tag "MyString"
    sms false
    email false
  end
end
