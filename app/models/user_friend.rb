# == Schema Information
#
# Table name: user_friends
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  send_sms   :boolean          default(FALSE)
#  send_email :boolean          default(FALSE)
#  phone      :string(255)
#

class UserFriend < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  
  has_many :user_locations, :through => :user
  has_many :locations, :through => :user_locations
  
  acts_as_taggable
  acts_as_mappable :through => :locations

  validate :user_not_self_friend
  validates_uniqueness_of :friend_id, scope: :user_id

  BASE_TAGS = [['Close Friends', 'close_friends'], ['Family', 'family'], ['OHW Network', 'ohw_network']]

  def user_not_self_friend
    errors.add(:friend_id, "can't be the same as you") if user_id == friend_id
  end

  def update_provider_friend(following)
    if friend && friend.provider_friend
      user_provider_friend = UserProviderFriend.find_or_initialize_by_user_id_and_provider_friend_id(user_id: user_id, provider_friend_id: friend.provider_friend.id)
      user_provider_friend.update_attributes(following: following)
    end
  end
  
  class << self

    def friend_relationship(user, friend)
      UserFriend.where(user_id: user.id, friend_id: friend.id).first
    end
    
    def friends_in_clause(user, friend_ids)
      UserFriend.where(user_id: user.id).where('friend_id IN (?)', friend_ids)
    end

    def followers_count(user)
      UserFriend.where(friend_id: user.id).count
    end

    def following_count(user)
      UserFriend.where(user_id: user.id).count
    end
    
    def user_friends_by_tag(user, tag, page)
      if user
        if tag
          results = UserFriend.tagged_with(tag).where(user_id: user.id).page(page)
        else
          results = UserFriend.where(user_id: user.id).page(page)
        end
      end
      results
    end

    def user_friends_by_tag_ids(user, tag)
      UserFriend.select(:friend_id).tagged_with(tag).where(user_id: user.id)
    end

    def user_friends_ids(user)
      UserFriend.select(:friend_id).where(user_id: user.id)
    end

    def users_with_current_location(user, current='t', page)
      where_clause = "(user_locations.current = :current AND user_friends.user_id = :user_id)"
      params = {current: current, user_id: user.id}
      join = "INNER JOIN users ON users.id = user_friends.friend_id INNER JOIN user_locations ON user_locations.user_id = users.id INNER JOIN locations ON locations.id = user_locations.location_id"
      UserFriend.joins(join).where(where_clause, params).page(page)
    end

    def user_friends_not_ohw_user_in_city_state_country(user, location, page, current='t')
      where_clause = "locations.state_id = :state_id AND locations.country_id = :country_id AND user_locations.current = :current AND user_friends.user_id = :user_id"
      where_clause << " AND locations.city_id = :city_id" if location.city
      params = {uid: user.provider('facebook').uid, user_id: user.id, city_id: location.city_id, state_id: location.state_id, country_id: location.country_id, current: current}
      join = "INNER JOIN users ON users.id = user_friends.friend_id INNER JOIN user_locations ON user_locations.user_id = users.id INNER JOIN locations ON locations.id = user_locations.location_id"
      join << " INNER JOIN cities ON locations.city_id = cities.id"
      join << " INNER JOIN states ON states.id = locations.state_id"
      join << " INNER JOIN countries ON countries.id = locations.country_id"

      UserFriend.joins(join).where(where_clause, params).page(page)
    end

    def grouped_user_friends_not_ohw_user_in_country(user, country_code, current='t')
      where_clause = "user_locations.current = :current AND user_friends.user_id = :user_id AND country_code = :country_code"
      params = {current: current, user_id: user.id, country_code: country_code}
      join = "INNER JOIN users ON users.id = user_friends.friend_id INNER JOIN user_locations ON user_locations.user_id = users.id INNER JOIN locations ON locations.id = user_locations.location_id"
      UserFriend.select('count(*) as count_all, city_name, state_name, locations.id, state_id').joins(join).where(where_clause, params).group('locations.id, city_name, state_name, state_id').order('state_name, city_name')
    end

    def grouped_user_friends_not_ohw_user_in_world(user, current="t")
      where_clause = "user_locations.current = :current AND user_friends.user_id = :user_id"
      params = {current: current, user_id: user.id}
      join = "INNER JOIN users ON users.id = user_friends.friend_id INNER JOIN user_locations ON user_locations.user_id = users.id INNER JOIN locations ON locations.id = user_locations.location_id"
      UserFriend.select('count(*) as count_all, city_name, country_name, locations.id, country_id').joins(join).where(where_clause, params).group('locations.id, city_name, country_name, country_id').order('country_name, city_name')
    end

    def all_user_friends(user, page)
      UserFriend.where(user_id: user.id).page(page)
    end

    def all_user_followers(user, page)
      UserFriend.where(friend_id: user.id).page(page)
    end

    def user_friends_nearby_location(user, location, page)
      if (user && location)
        where_clause = "(user_friends.user_id = :user_id) AND user_locations.current = :current"
        params = {user_id: user.id, current: true}
        users = UserFriend.joins(:friend => {:user_locations => :location}).within(DEFAULT_RADIUS, :origin => [location.latitude, location.longitude]).where(where_clause, params).page(page)
      else
        users = UserFriend.none.page(page)
      end
      users
    end

    def user_friends_in_country_state(user, country_id, state_id, page)
      if (location)
        where_clause = "(user_friends.user_id = :user_id) AND user_locations.current = :current AND country_id = :country_id"
        where_clause << " AND state_id = :state_id" if state_id
        params = {user_id: user.id, current: true, country_id: country_id, state_id: state_id}
        users = UserFriend.joins(:friend => {:user_locations => :location}).where(where_clause, params).page(page)
      else
        users = []
      end
      users
    end
    
    def user_friends_nearby(user, current='t', page)
      if (user.current_location)
        location = user.current_location.location
        where_clause = "(user_locations.current = :current AND user_friends.user_id = :user_id)"
        params = {current: current, user_id: user.id}
        join = "INNER JOIN users ON users.id = user_friends.friend_id INNER JOIN user_locations ON user_locations.user_id = users.id INNER JOIN locations ON locations.id = user_locations.location_id"
        UserFriend.joins(join).within(DEFAULT_RADIUS, :origin => [location.latitude, location.longitude]).where(where_clause,
          params).page(page)
      else
        []
      end
    end
  end
end
