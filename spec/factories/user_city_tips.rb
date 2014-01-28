# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_city_tip do
    user_id 1
    city_id 1
    tip "MyText"
    rating "9.99"
  end
end
