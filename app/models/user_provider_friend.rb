# == Schema Information
#
# Table name: user_provider_friends
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  provider_friend_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  following          :boolean
#  email              :string(255)
#  phone              :string(255)
#

class UserProviderFriend < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider_friend

  acts_as_taggable
  
  self.include_root_in_json = true

  default_scope includes(:provider_friend)

  class << self
    def my_friends_followed_not_ohw(user, tag=nil, page=1)
      if user
        where = 'user_provider_friends.user_id = ? AND provider_friends.user_id IS NULL'
        if tag
          results = UserProviderFriend.joins(:provider_friend).includes(:user).where(where, user.id).order('provider_friends.user_name').tagged_with(tag)
        else
          where << ' AND following = true'
          results = UserProviderFriend.joins(:provider_friend).includes(:user).where(where, user.id).order('provider_friends.user_name')
        end
        results.page(page)
      end
    end

    def my_friends_to_follow(user, page=1)
      UserProviderFriend.joins(:provider_friend).includes(:user).where(user_id: user.id).order('provider_friends.user_id, provider_friends.user_name').page(page)
    end

    def with_provider_friend_uid(user_provider, provider_name)
      UserProviderFriend.joins(:provider_friend).where('provider_friends.provider_name = ? AND provider_friends.uid = ?', provider_name, user_provider.uid).first
    end

    def ohw_user(user_friend)
      UserProviderFriend.includes(:provider_friend).where('provider_friends.user_id = ?', user_friend.friend_id).first
    end
  end
end
