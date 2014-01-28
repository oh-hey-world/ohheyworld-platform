# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registration_code do
    code "MyString"
    uses 1
  end
end
