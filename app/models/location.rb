# == Schema Information
#
# Table name: locations
#
#  id           :integer          not null, primary key
#  latitude     :float
#  longitude    :float
#  address      :string(255)
#  city_name    :string(255)
#  state_name   :string(255)
#  state_code   :string(255)
#  postal_code  :string(255)
#  country_name :string(255)
#  country_code :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_input   :string(255)
#  residence    :boolean
#  state_id     :integer
#  country_id   :integer
#  city_id      :integer
#

class Location < ActiveRecord::Base
  has_many :user_locations, :dependent => :destroy
  has_many :users, :through => :user_locations
  has_many :provider_friends
  has_many :user_provider_friends, :through => :provider_friends
  has_many :home_country_users, :class_name => "User", :foreign_key => "home_town_location_id"
  belongs_to :country
  belongs_to :state
  belongs_to :city

  acts_as_mappable  :default_units => :miles,
                    :default_formula => :sphere,
                    :distance_field_name => :distance,
                    :lat_column_name => :latitude,
                    :lng_column_name => :longitude
  
  self.include_root_in_json = true
  validates_presence_of :user_input
  before_validation :check_geocode
  before_save :check_city_state_country
  
  #TOOD add_index :locations, :user_input, :unique => true #need to write task to clean up first
  
  def check_geocode
    #user_input should never change after first instance so don't geocode again
    self.geocode if ((!self.latitude || !self.longitude) && !self.user_input.blank?)
  end

  def check_city_state_country
    country = Country.find_or_create_by_name(country_name) if (country_name && !country_id)
    if (country)
      self.country = country
      state = State.find_or_create_by_name_and_country_id(state_name, country_id) if (state_name && !state_id)
      self.state = state
      city = City.find_or_create_by_name_and_state_id_and_country_id(city_name, state_id, country_id) if (city_name && !city_id)
      self.city = city
      self.country_name = country.name
    end
  end
  
  geocoded_by :user_input do |item,results|
    if geo = results.first
      item.address = geo.address
      item.latitude = geo.latitude
      item.longitude = geo.longitude
      item.state_name = geo.state
      item.state_code = geo.state_code
      item.country_name = geo.country
      item.country_code = geo.country_code
      item.city_name = geo.city
      item.postal_code = geo.postal_code
    else
      Rails.logger.info results
      item.errors.add(:address, "cannot be determined, please try again.")
    end
  end
  
  def name
    city_or_state = (city_name) ? city_name : state_name
    (city_or_state) ? city_or_state : address
  end

  def city_state_country
    [city_name, state_name, country_name].compact().join(', ')
  end

  def full_address
    [street, city_name, state_name, country_name].compact.join(', ')
  end
  
  class << self

    def location_user_provider_friends(user, page, page_override=false)
      where_clause = "provider_friends.uid != :uid AND user_provider_friends.user_id = :user_id"
      params = {uid: user.provider('facebook').uid, user_id: user.id}

      results = Location.joins(:provider_friends, :user_provider_friends).where(where_clause, params).order(:address)

      (page_override) ? results : results.page(page)
    end

    def find_or_create_by_user_input(user_input)
      location = Location.find_by_user_input(user_input)
      location = Location.create(user_input: user_input) unless location
      location
    end
    
    def countries_visited(user)
      Location.select('country_code').joins(:user_locations).where("user_locations.user_id = ?", user.id).group('locations.country_code')
    end
    
    def search_address(query, limit=25)
      locations = Location.select('address, id').where("address ILIKE ?", "#{query}%").group(:address, :id).limit(limit)
      locations.uniq!{ |x| x.address }
      locations
    end
    
    def parse_provider_location(provider_location)
      unless provider_location.blank?
        location_info = provider_location.split(',')
        location_city = location_info[0]
        location_state = location_info[1].lstrip if location_info[1]
      end
      return location_city, location_state
    end

    def reset_resave_country_city_state
      Location.update_all(country_id: nil, state_id: nil, city_id:nil)
      Location.where('LENGTH(country_name) = 2').update_all(latitude: nil, longitude: nil)
      Country.delete_all
      State.delete_all
      City.delete_all
      Location.where(latitude: nil).find_each do |location|
        location.save
        sleep 1
      end
    end
  end
end
