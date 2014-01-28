if Rails.env.development?
  require "ffaker"
end

namespace :db do
  desc "Populate development DB with fake data for display purposes"
  task populate: :environment do
    unless Rails.env.production?
      Rake::Task['db:reset'].invoke
      make_locations
      make_access_users
      make_dummy_users
      make_and_assign_demo_community
    else
      raise "Do not run this script in production"
    end
  end
end


def make_locations
  location = Location.new
  location.assign_attributes({id: 1,
                              latitude: 47.60356,
                              longitude: -122.32944,
                              address: "Seattle, WA, United States",
                              city_name: "Seattle",
                              state_name: "Washington",
                              state_code: "WA",
                              postal_code: "",
                              country_name: "United States",
                              country_code: "US",
                              created_at: "2013-05-27 18:27:34",
                              updated_at: "2013-05-27 18:27:34",
                              user_input: "Seattle, WA, US",
                              residence: nil,
                              state_id: 1,
                              country_id: 1,
                              city_id: 1
                            }, without_protection: true )
  location.save!

  location = Location.new
  location.assign_attributes({id: 2,
                              latitude: 37.77713,
                              longitude: -122.41964,
                              address: "San Francisco, CA, United States",
                              city_name: "San Francisco",
                              state_name: "California",
                              state_code: "CA",
                              postal_code: "",
                              country_name: "United States",
                              country_code: "US",
                              created_at: "2013-05-27 20:40:45",
                              updated_at: "2013-05-27 20:40:45",
                              user_input: "San Francisco, CA",
                              residence: nil,
                              state_id: 2,
                              country_id: 1,
                              city_id: 2
                            }, without_protection: true)
  location.save!
end

def make_access_users
  admin_details = { first_name: "OHW", last_name: "Administrator", email: "admin@ohw.com", nickname: "Administrator Jones" }
  user_details = { first_name: "OHW", last_name: "Observer", email: "user@ohw.com", nickname: "User Jones" }

  generate_user(1, true, admin_details)
  generate_user(1, false, user_details)
end

def make_and_assign_demo_community
  community = Community.new(name: "Kiva", question: "Why do you lend?", concern_list: "microfinance, travel, education")
  community.community_profiles.build(admin: true, answer: "Because I care.", tagline: "I'm a giver.", user: User.find_by_email("admin@ohw.com"))
  community.save!

  User.all.each do |user|
    if user.community_profiles.empty?
      user = user.community_profiles.build(answer: "#{Faker::HipsterIpsum.sentence}", tagline: "#{Faker::HipsterIpsum.sentence}", community: Community.all.first) if rand * 10 <= 5
      user.save!
    end
  end
end

def make_dummy_users
  40.times do |n|
    generate_user(1, false) #seattle
  end

  40.times do |n|
    generate_user(2, false) #sanfran
  end
end

def generate_user(loc_id, admin, args={})
  if args.empty?
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    nickname = "#{Faker::HipsterIpsum.word} #{Faker::Product.brand}"
  else
    first_name = args[:first_name]
    last_name = args[:last_name]
    email = args[:email]
    nickname = args[:nickname]
  end

  user = User.new
  user.assign_attributes({first_name: first_name,
                          last_name: last_name,
                          email: email,
                          nickname: nickname,
                          password: "password",
                          completed_first_checkin: true,
                          user_locations: [user_loc(user.id, loc_id)],
                          interest_list: "travel, microfinance, education, running, jumping, climbing trees"
                          }, without_protection: true)

  user.save!
  user.confirm!

  user.make_admin if admin == true
end

def user_loc(user_id, loc_id)
    loc = UserLocation.new( user_id: user_id,
                            location_id: loc_id,
                            current: true,
                            private: false)
    loc
end
