# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_contact do
    user_id 1
    contact_id 1
    subject "MyString"
    message "MyText"
    email "MyString"
    phone "MyString"
  end
end
