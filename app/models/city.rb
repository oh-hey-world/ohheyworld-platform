# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state_id   :integer
#  country_id :integer
#  slug       :string(255)
#

class City < ActiveRecord::Base
  belongs_to :state
  belongs_to :country
  has_many :user_cities

  extend FriendlyId
  friendly_id :city_state_country, use: :slugged

  validates_presence_of :country
  validates_uniqueness_of :name, :scope => [:state_id]
  before_validation :check_geocode

  def check_geocode
    self.geocode if ((!self.latitude || !self.longitude) && !self.name.blank?)
  end

  def state_name
    (state) ? state.name : ""
  end

  def city_state_names
    [name, state_name].reject(&:blank?).join(', ')
  end

  def city_state_country
    name_parts = [name, state_name]
    name_parts << country.name if country
    name_parts.compact.join(', ')
  end

  geocoded_by :city_state_country do |item,results|
    if geo = results.first
      item.latitude = geo.latitude
      item.longitude = geo.longitude
      item.name = geo.city
    else
      Rails.logger.info results
      item.errors.add(:name, "cannot be determined, please try again.")
    end
  end
end
