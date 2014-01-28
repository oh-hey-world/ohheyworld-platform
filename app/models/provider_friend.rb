# == Schema Information
#
# Table name: provider_friends
#
#  id            :integer          not null, primary key
#  provider_name :string(255)
#  user_name     :string(255)
#  uid           :string(255)
#  picture_url   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  link          :string(255)
#  location_id   :integer
#  user_id       :integer
#  username      :string(255)
#  email         :string(255)
#  phone         :string(255)
#

class ProviderFriend < ActiveRecord::Base  
  belongs_to :location
  belongs_to :user
  has_many :user_locations, :through => :user
  has_many :locations, :through => :user_locations
  has_many :user_location_tagged_users, :dependent => :destroy
  has_many :user_provider_friends, :dependent => :destroy
  has_many :users, :through => :user_provider_friends do
    def <<(*items)
      super( items - @association.owner.users )
    end
  end
  
  self.include_root_in_json = true
  self.per_page = 12
  acts_as_mappable :through => :location

  default_scope includes(:user)

  SELECT_DISTINCT = 'DISTINCT provider_friends.id, provider_name, user_name, uid, provider_friends.picture_url, provider_friends.created_at, provider_friends.updated_at, provider_friends.link, provider_friends.location_id, provider_friends.user_id, provider_friends.username, provider_friends.email, provider_friends.phone'
  
  def current_location
    user_location = user_locations.detect{|x| x.current == true}
  end
  
  class << self

    def provider_friend_user_ids(user, provider_name)
      return [] unless user.provider('facebook')
      where_clause = "provider_friends.uid != :uid AND user_provider_friends.user_id = :user_id AND provider_friends.user_id IS NOT NULL"
      params = {uid: user.provider(provider_name).uid, user_id: user.id}

      results = ProviderFriend.select('provider_friends.user_id').joins(:user_provider_friends).includes(:user).where(where_clause, params)
    end

    def user_provider_friends_of_friends_not_ohw_user(user, location, provider_name, page_override=false, page)
      return ProviderFriend.none.page(page) unless user && user.provider('facebook')
      where_clause = "provider_friends.uid != :uid AND user_provider_friends.user_id in (:user_ids) AND provider_friends.id NOT IN (SELECT provider_friend_id FROM user_provider_friends WHERE user_id = :user_id)"
      params = {uid: user.provider('facebook').uid, user_ids: ProviderFriend.provider_friend_user_ids(user, provider_name).map(&:user_id), user_id: user.id}
      results = ProviderFriend.select(SELECT_DISTINCT).joins(:user_provider_friends, :location).includes(:user).within(DEFAULT_RADIUS, :origin => [location.latitude, location.longitude]).where(where_clause, params) #.group('provider_friends.id')
      (page_override) ? results : results.page(page)
    end

    def user_friends_with_location(user, page, page_override=false)
      return ProviderFriend.none.page(page) unless user && user.provider('facebook')
      where_clause = "provider_friends.uid != :uid AND user_provider_friends.user_id = :user_id"
      params = {uid: user.provider('facebook').uid, user_id: user.id}

      results = ProviderFriend.joins(:user_provider_friends, :location).includes(:user).where(where_clause, params).order(:address)

      (page_override) ? results : results.page(page)
    end


    def user_friends_not_ohw_user(user, location, page_override=false, page)
      return ProviderFriend.none.page(page) unless user && user.provider('facebook')
      where_clause = "provider_friends.uid != :uid AND user_provider_friends.user_id = :user_id AND (users.id NOT IN (SELECT friend_id FROM user_friends WHERE user_id = :user_id) OR provider_friends.user_id IS NULL)"
      params = {uid: user.provider('facebook').uid, user_id: user.id}
      results = ProviderFriend.select(SELECT_DISTINCT).joins(:user_provider_friends, :location).includes(:user_locations, :user).within(DEFAULT_RADIUS, :origin => [location.latitude, location.longitude]).where(where_clause, params)
      (page_override) ? results : results.page(page)
    end

    def user_friends_not_ohw_user_in_city_state_country(user, location, page)
      return [] unless user.provider('facebook')
      where_clause = "provider_friends.uid != :uid AND user_provider_friends.user_id = :user_id AND locations.state_id = :state_id AND locations.country_id = :country_id"
      where_clause << " AND locations.city_id = :city_id" if location.city
      params = {uid: user.provider('facebook').uid, user_id: user.id, city_id: location.city_id, state_id: location.state_id, country_id: location.country_id}

      results = ProviderFriend.joins(:user_provider_friends, :location => [:city, :state, :country]).where(where_clause, params).page(page)
    end

    def grouped_user_friends_not_ohw_user_in_country(user, country_code)
      return [] unless user.provider('facebook')
      where_clause = "provider_friends.uid != :uid AND user_provider_friends.user_id = :user_id AND country_code = :country_code"
      params = {uid: user.provider('facebook').uid, user_id: user.id, country_code: country_code}

      results = ProviderFriend.select('count(*) as count_all, city_name, state_name, locations.id, state_id').joins(:user_provider_friends, :location).where(where_clause,
        params).group('locations.id, city_name, state_name, state_id').order('state_name, city_name')
    end

    def grouped_user_friends_not_ohw_user_in_world(user)
      return [] unless user.provider('facebook')
      where_clause = "provider_friends.uid != :uid AND user_provider_friends.user_id = :user_id"
      params = {uid: user.provider('facebook').uid, user_id: user.id}

      results = ProviderFriend.select('count(*) as count_all, city_name, country_name, locations.id, country_id').joins(:user_provider_friends, :location).where(where_clause,
        params).group('locations.id, city_name, country_name, country_id').order('country_name, city_name')
    end

    def user_friends_ohw_user(user, location, page_override=false, page)
      return [] unless user.provider('facebook')
      where_clause = "provider_friends.uid != :uid AND user_provider_friends.user_id = :user_id AND provider_friends.user_id IS NOT NULL AND (user_locations.current = :current AND user_locations.private = false)"
      params = {uid: user.provider('facebook').uid, user_id: user.id, current: true}

      results = ProviderFriend.joins(:user_provider_friends, :user_locations => :location).includes(:user, :user_locations).within(DEFAULT_RADIUS, :origin => [location.latitude, location.longitude]).where(where_clause,
        params)

      (page_override) ? results : results.page(page)
    end
  end
end
