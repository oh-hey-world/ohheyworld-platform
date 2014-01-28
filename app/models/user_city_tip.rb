# == Schema Information
#
# Table name: user_city_tips
#
#  id             :integer          not null, primary key
#  tip            :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_city_id   :integer
#  travel_profile :string(255)
#  link_name      :string(255)
#  link_value     :string(255)
#

class UserCityTip < ActiveRecord::Base
  belongs_to :user_city, counter_cache: true

  validates :user_city_id, presence: true
  validates :tip, presence: true
  validates :link_value, format: URI::regexp(%w(http https)), allow_blank: true

  attr_accessible :rating, :tip, :user_city_id, :travel_profile, :tag_list, :link_name, :link_value

  acts_as_taggable
  acts_as_votable

  TRAVEL_PROFILE_TYPES = %w[digital_nomad family backpacker long_term_volunteer
    budget_backpacker outdoors/adventure_traveler romantic_getaway business_traveler luxury_traveler]

  class << self
    def distict_travel_profiles(user_city)
      where_clause = 'city_id = :city_id AND travel_profile IS NOT NULL AND char_length(travel_profile) > 0'
      where_clause << ' AND (user_id = :user_id OR user_id IS NULL)' if user_city.user_id
      params = {city_id: user_city.city_id, user_id: user_city.user_id}
      UserCityTip.select('DISTINCT travel_profile').joins(:user_city).where(where_clause, params)
    end

    def total_tips_for_city(city_id)
      UserCityTip.joins(:user_city).where('city_id = ?', city_id).count
    end

    def group_tips_by_tag(user_city_tips)
      grouped_tips = {}
      first_profile = nil
      if user_city_tips
        user_city_tips.each do |tip|
          first_profile = tip.travel_profile unless first_profile
          if tip.tags.count == 0
            if grouped_tips.has_key?(:other)
              grouped_tips[:other] << tip
            else
              grouped_tips[:other] = [tip]
            end
          else
            first_tip = tip.tags.first.name.to_sym
            if grouped_tips.has_key?(first_tip)
              grouped_tips[first_tip] << tip
            else
              grouped_tips[first_tip] = [tip]
            end
          end
        end
      end
      return grouped_tips, first_profile
    end

    def tips_by_user_for_city(user, city_id, travel_profile, page=1)
      where_clause = nil
      params = nil
      if user
        where_clause = 'user_cities.user_id = :user_id AND user_cities.city_id = :city_id'
        params = {user_id: user.id, city_id: city_id}
      else
        where_clause = 'user_cities.user_id IS NULL AND user_cities.city_id = :city_id'
        params = {city_id: city_id}
      end
      if travel_profile
        where_clause << " AND travel_profile = :travel_profile"
        params[:travel_profile] = travel_profile
      end
      UserCityTip.joins(:user_city).where(where_clause, params).page(page)
    end
  end
end
