# == Schema Information
#
# Table name: user_providers
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  provider                 :string(255)
#  uid                      :string(255)
#  first_name               :string(255)
#  last_name                :string(255)
#  gender                   :string(255)
#  timezone                 :integer
#  locale                   :string(255)
#  link                     :string(255)
#  hometown                 :string(255)
#  picture_url              :string(255)
#  provider_token           :string(255)
#  provider_token_timeout   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  secret                   :string(255)
#  full_name                :string(255)
#  nickname                 :string(255)
#  description              :text
#  website                  :string(255)
#  geo_enabled              :boolean
#  failed_post_deauthorized :boolean
#  failed_token             :boolean
#  failed_app_deauthorized  :boolean
#

class UserProvider < ActiveRecord::Base
  belongs_to :user
  after_create :check_provider_friend
  
  attr_accessible :uid, :link, :provider_token, :user_id, :provider,
    :provider_token_timeout, :hometown, :picture_url,
    :gender,  :timezone, :locale, :first_name, :last_name, 
    :secret, :full_name, :nickname, :description, :website, :geo_enabled,
    :failed_post_deauthorized, :failed_app_deauthorized
  
  def save_twitter_auth(access_token)
    token = access_token['credentials']['token']
    secret = access_token['credentials']['secret']
    picture_url = access_token["info"]["image"]
    location = access_token["info"]["location"]
    nickname = access_token["info"]["nickname"]
    full_name = access_token["info"]["name"]
    description = access_token["info"]["description"]
    website = access_token["info"]["urls"]["Website"] if access_token["info"]["urls"]
    link = access_token["info"]["urls"]["Twitter"] if access_token["info"]["urls"]
    data = access_token['extra']['raw_info']
=begin
"statuses_count" => 447,
    "created_at" => "Sat Jan 19 15:43:17 +0000 2008",
"followers_count" => 69,
      "verified" => false,
 "friends_count" => 51,
          "lang" => "en",
=end
    provider_params = {uid: access_token.uid, link: link, provider_token: token, secret: secret,
      picture_url: picture_url, gender: data["gender"],  timezone: data["timezone"], locale: data["locale"], 
      first_name: data["first_name"], last_name: data["last_name"], full_name: full_name, nickname: nickname,
      description: description, website: website, geo_enabled: data["geo_enabled"], user_id: self.user_id}
    self.update_attributes(provider_params)
  end
  
  def token_valid?
    case self.provider
      when 'facebook'
        self.facebook_token_valid?
      when 'twitter'
        self.twitter_token_valid?
    end
  end
  
  def facebook_token_valid?
    (!self.provider_token_timeout.blank? && !(Time.now.to_i > self.provider_token_timeout))
  end
  
  def twitter_token_valid?
    (!self.provider_token.blank? && !self.secret.blank?)
  end

  def save_facebook(access_token)
    token = access_token['credentials']['token']
    data = access_token['extra']['raw_info']
    description = data["bio"]
    provider_token_timeout = access_token['credentials']['expires_at']
    location = access_token["info"]["location"]
    full_name = access_token["info"]["name"]
    username = data[:username]
    username = full_name.gsub(/\s+/, "") if username.blank?
    picture_url = ["http://graph.facebook.com", username, "picture"].join("/")
    birthday = Chronic::parse(data["birthday"])
    home_town_name = nil
    home_town_location = nil
    if data["hometown"]
      home_town_name = data["hometown"]["name"]
    end

    provider_params = {uid: access_token.uid, link: data["link"], provider_token: token,
                       provider_token_timeout: provider_token_timeout, hometown: home_town_name, picture_url: picture_url,
                       gender: data["gender"],  timezone: data["timezone"], locale: data["locale"],
                       first_name: data["first_name"], last_name: data["last_name"], full_name: full_name,
                       failed_post_deauthorized: false, failed_app_deauthorized: false, description: description}
    self.update_attributes(provider_params)
  end

  def check_provider_friend
    user_provider_friend = UserProviderFriend.with_provider_friend_uid(self, provider)
    UserFriend.find_or_create_by_user_id_and_friend_id(user_provider_friend.user_id, id) if user_provider_friend && user_provider_friend.following
  end

  class << self
    def find_twitter_by_auth(user, access_token)
      user_provider = UserProvider.find_or_create_by_provider_and_user_id(user_id: user.id, provider: access_token.provider)
    end
    
    def registered_user(name, uid)
      UserProvider.where(provider: name, uid: uid).first
    end
  end
end
