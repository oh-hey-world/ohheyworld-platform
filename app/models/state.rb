# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  link       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :integer
#  code       :string(255)
#  latitude   :float
#  longitude  :float
#

class State < ActiveRecord::Base
  has_many :locations
  belongs_to :country
  has_many :cities

  validates_presence_of :country
  validates_uniqueness_of :name, scope: :country_id
  validates_uniqueness_of :code, scope: :country_id

  before_validation :check_geocode

  attr_accessor :provider_friends, :user_friends

  def check_geocode
    self.geocode if ((!self.latitude || !self.longitude) && !self.name.blank?)
  end

  def state_country
    (country) ? "#{name}, #{country.name}" : name
  end

  def country_name
    country.name
  end

  geocoded_by :state_country do |item,results|
    if geo = results.first
      item.latitude = geo.latitude
      item.longitude = geo.longitude
      item.name = geo.state
      item.code = geo.state_code
    else
      Rails.logger.info results
      item.errors.add(:name, "cannot be determined, please try again.")
    end
  end

  class << self
    def by_ids(ids)
      State.where('id in (?)', ids)
    end
  end
end
