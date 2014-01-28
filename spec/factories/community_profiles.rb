# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :community_profile do
    user_id 1
    community_id 1
    tagline "MyText"
    answer "MyText"
  end
end
