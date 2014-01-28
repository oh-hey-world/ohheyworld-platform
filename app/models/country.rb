# == Schema Information
#
# Table name: countries
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  link              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  flag_file_name    :string(255)
#  flag_content_type :string(255)
#  flag_file_size    :integer
#  flag_updated_at   :datetime
#  code              :string(255)
#  latitude          :float
#  longitude         :float
#  phone_code        :string(255)
#

class Country < ActiveRecord::Base
  has_many :user_countries
  has_many :users, :through => :user_countries
  has_many :locations
  has_many :states

  validates_uniqueness_of :code, :name

  before_validation :check_geocode

  attr_accessible :name, :link, :flag, :phone_code
  attr_accessor :provider_friends, :user_friends
  
  has_attached_file :flag, :styles => { :medium => "360x300>", :thumb => "140x100>", :small => '48x33>' }

  def check_geocode
    self.geocode if ((!self.latitude || !self.longitude) && !self.name.blank?)
  end

  geocoded_by :name do |item,results|
    if geo = results.first
      item.latitude = geo.latitude
      item.longitude = geo.longitude
      item.name = geo.country
      item.code = geo.country_code
    else
      Rails.logger.info results
      item.errors.add(:name, "cannot be determined, please try again.")
    end
  end

  def flag_url
    self.flag.url
  end

  class << self
    def by_ids(ids)
      Country.where('id in (?)', ids)
    end

    def with_phone_codes
      Country.where('phone_code IS NOT NULL').order(:phone_code)
    end
  end
end
