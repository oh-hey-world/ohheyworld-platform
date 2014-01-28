# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  encrypted_password      :string(255)      default(""), not null
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0)
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  first_name              :string(255)
#  last_name               :string(255)
#  gender                  :string(255)
#  timezone                :integer
#  locale                  :string(255)
#  picture_url             :string(255)
#  link                    :string(255)
#  blurb                   :text
#  birthday                :datetime
#  roles_mask              :integer
#  blog_url                :string(255)
#  home_town_location_id   :integer
#  nickname                :string(255)      not null
#  slug                    :string(255)      not null
#  agrees_to_terms         :boolean
#  completed_first_checkin :boolean
#  import_job_id           :integer
#  import_job_finished_at  :datetime
#  send_overrides          :text
#  authentication_token    :string(255)
#  phone                   :string(255)
#  confirmation_token      :string(255)
#  confirmed_at            :datetime
#  confirmation_sent_at    :datetime
#  unconfirmed_email       :string(255)
#  phone_country_code_id   :integer
#

require 'twilio-ruby'

class User < ActiveRecord::Base
  include Preferences
  include Rails.application.routes.url_helpers

  before_create :set_default_roles, :set_picture_url
  before_validation :set_nickname
  before_save :format_phone, :check_blog_url
  #after_create :send_welcome_mail

  ROLES = %w[admin standard content_creator]
  NOTIFICATION_PREFERENCES = %w[facebook twitter sms_friends email_friends]

  acts_as_taggable
  acts_as_taggable_on :skill, :interests, :non_profits_and_causes, :extreme_experiences, :festivals, :favorite_experiences
  acts_as_tagger
  acts_as_voter
  scope :by_join_date, order("created_at DESC")
  scope :location_private, where(private: true)
  scope :not_private, where(private: false)

  #communities
  has_many :communities, through: :community_profiles
  has_many :community_profiles

  has_many :user_tag_notifications, :dependent =>  :destroy
  has_many :user_providers, :dependent => :destroy
  has_many :user_countries
  has_many :countries, :through => :user_countries
  has_many :user_languages
  has_many :languages, :through => :user_languages
  has_many :user_locations, :dependent => :destroy
  has_many :locations, :through => :user_locations
  has_many :user_searches, :dependent => :destroy
  has_many :location_searches, :through => :user_searches
  has_many :user_provider_friends, :dependent => :destroy
  has_many :provider_friends, :through => :user_provider_friends
  has_many :notification_contact_details, :dependent => :destroy
  has_many :user_friends, dependent: :destroy
  has_many :friends, :class_name => "UserFriend", :foreign_key => "friend_id", :dependent => :destroy
  has_many :friends_of, :through => :friends
  has_many :user_contacts, dependent: :destroy
  has_many :contacts, :class_name => "UserContact", :foreign_key => "contact_id", :dependent => :destroy
  has_many :user_assets, dependent: :destroy
  has_many :user_cities, dependent: :destroy
  has_many :user_city_tips, :through => :user_cities
  has_many :user_location_notes, :dependent => :destroy
  has_one :provider_friend, dependent: :destroy
  belongs_to :home_location, :class_name => "Location", :foreign_key => "home_town_location_id"
  belongs_to :phone_country, :class_name => "Country", :foreign_key => "phone_country_code_id"
  accepts_nested_attributes_for :notification_contact_details, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? || attributes['value'].blank? }
  accepts_nested_attributes_for :user_tag_notifications, :allow_destroy => true
  accepts_nested_attributes_for :user_locations, :allow_destroy => true
  accepts_nested_attributes_for :user_assets, :allow_destroy => true
  validates_format_of :phone,
    :with => /^(\+\d{1})?(\+\d{2})?[0-9]{3}?[\-|\s|\.]?[0-9]{3}[\-|\s|\.]?[0-9]{4}$/,
    :message => "is not a valid phone number",
    :allow_nil => true,
    :allow_blank => true
  validates_uniqueness_of :phone, :allow_nil => true

  #TODO add validation for types and urls etc
  extend FriendlyId
  friendly_id :nickname, use: :slugged

  preference :value_from_finding_friends_preference, false
  preference :facebook, true
  preference :twitter, true
  preference :sms_friends, true
  preference :email_friends, true
  preference :shows_contact_info, true
  preference :shows_user_locations, true
  preference :nomadic, false
  preference :email_close_following, true
  preference :sms_close_following, false
  preference :opt_out_of_email, false
  preference :checkins_default_private, false
  preference :email_for_comment, true
  preference :email_for_like, true

  self.per_page = 10
  acts_as_mappable :through => :locations

  default_scope includes(:user_providers)

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :first_name, :last_name, :last_location, :gender, :timezone, :locale,
    :hometown, :picture_url, :twitter, :preferences,
    :notification_contact_details_attributes, :link, :blurb, :birthday, :blog_url,
    :language_ids, :country_ids, :home_town_location_id, :nickname, :completed_first_checkin,
    :import_job_finished_at, :import_job_id, :send_overrides, :tag_list, :interest_list, :skill_list,
    :non_profits_and_cause_list, :extreme_experience_list, :festival_list, :favorite_experience_list,
    :home_location, :phone, :interests_joined, :phone_country_code_id, :user_tag_notifications_attributes,
    :user_locations_attributes, :user_assets_attributes, :slug
  attr_accessor :twilio_errors, :interests_joined, :description

  serialize :send_overrides, Hash

  def all_tags
    tags = tag_list.concat(interest_list)
    tags.concat(skill_list)
    tags.concat(non_profits_and_cause_list)
    tags.concat(extreme_experience_list)
    tags.concat(festival_list)
    tags.concat(favorite_experience_list)
    tags.to_a.compact
  end

  def format_phone
    if phone?
      self.phone = "#{phone.gsub(" ", "").gsub("-", "").gsub(".", "")}"
      self.phone = "#{phone_country.phone_code}#{phone}" unless phone.start_with? "+"
    end
  end

  def check_blog_url
    if !blog_url.blank? && !blog_url.start_with?('http://')
      self.blog_url = "http://#{blog_url}"
    end
  end

  def set_default_roles
    self.roles = ['standard']
  end

  def set_nickname
    if nickname.blank?
      self.write_preference('facebook', false)
      self.nickname = email.split("@").first
    end
  end

  def description
    description = blurb
    description = provider('twitter').description if !description && provider('twitter')
    description = provider('facebook').description if !description && provider('facebook')
    description
  end

  def profile_picture_url(params=nil)
    final_url = "#{picture_url}#{params}"
    user_asset_url = user_assets.detect{ |x| x.default == true }
    if user_asset_url
      if params
        height_param = params[/\bheight=(\d+)/i]
        if height_param
          height_size = height_param.split('=')[1].to_i
          case
            when height_size <= 50
              final_url = user_asset_url.asset.url(:small)
            when height_size <= 100
              final_url = user_asset_url.asset.url(:medium)
            else
              final_url = user_asset_url.asset.url(:large)
          end
        end
      else
        final_url = user_asset_url.asset.url(:large)
      end
    end
    final_url
  end

  def set_picture_url
    self.picture_url = "http://#{BASE_URL}/assets/default_profile.jpg" if picture_url.blank?
  end

  def send_welcome_mail
    NotificationMailer.welcome_email(self).deliver
  end

  def user_name
    [first_name, last_name].join(' ')
  end

  def first_or_last_name
    (first_name.blank?) ? last_name : first_name
  end

  def interests_joined=(param)
    self.interest_list = param
  end

  def interests_joined
    interest_list.join(", ")
  end

  def age
    date = self.birthday
    now = Time.now.utc.to_date
    now.year - date.year - ((now.month > date.month || (now.month == date.month && now.day >= date.day)) ? 0 : 1)
  end

  def next_location(user_location)
    user_locations.where('created_at > ?', user_location.created_at).order("created_at ASC").limit(1).first
  end

  def prior_location(user_location)
    user_locations.where('created_at < ?', user_location.created_at).order("created_at DESC").limit(1).first
  end

  def prior_locations(user_location, size=3)
    user_locations.where('created_at < ?', user_location.created_at).order("created_at DESC").limit(size).first
  end

  def most_recent_places(size=3)
    self.user_locations.includes(:location).order("created_at DESC").limit(size)
  end

  def current_location
    user_location = user_locations.includes(:location).detect{|x| x.current == true}
  end

  def most_recent_place
    self.user_locations.includes(:location).order("created_at DESC").limit(1).first
  end

  def second_most_recent_place
    self.user_locations.includes(:location).order("created_at DESC").offset(1).limit(1).first
  end

  def last_time_visited_place(location_id)
    self.user_locations.joins(:location).where(location_id: location_id).order("user_locations.created_at DESC").offset(1).limit(1)
  end

  def current_residence
    self.user_locations.where(residence: true).order("created_at DESC").limit(1).first
  end

  def countries_visited
    #where_clause = (self.home_location) ? "locations.country != '#{self.home_location.country}'" : ''
    self.user_locations.select('locations.country_code').joins(:location).group('locations.country_code')
  end

  def first_time_abroad
    self.user_locations.joins(:location).where("locations.country_code != ?", self.home_location.country_code).order("created_at").first if self.home_location
  end

  def is_at_home?
    (self.current_residence && self.current_location && self.current_residence.location.city_name == self.current_location.location.city_name && self.current_residence.location.state_name == self.current_location.location.state_name)
  end

  def ordered_locations(is_same_user, page=1, order="created_at DESC, ended_at DESC")
    page = 1 if page.blank?
    if is_same_user
      results = self.user_locations.page(page).per_page(12).order(order)
    else
      results = self.user_locations.where('private = false').page(page).per_page(12).order(order)
    end
    results
  end

  def provider(name)
    self.user_providers.select{|x| x.provider == name}.first
  end

  def provider_valid_enabled_authorized?(name)
    (provider_valid?(name) && provder_enabled?(name) && provider_authorized?(name))
  end

  def provider_authorized?(name)
    (!provider(name) || (provider(name) && !provider(name).failed_app_deauthorized && !provider(name).failed_post_deauthorized))
  end

  def provder_enabled?(name)
    provider_preference = self.read_preference(name)
    provider_preference = self.try(name) unless provider_preference
    (provider_preference && User.preference_true?(name, provider_preference.value))
  end

  def provider_valid?(name)
    provider = self.provider(name)
    (provider && provider.token_valid? && !provider.failed_app_deauthorized)
  end

  def total_days_traveled(date=1.year.ago)
    #prior_locations.inject(0) { |total, user_location| total + user_location.calculate_days_traveled }
    #TODO kludgy need to review
    prior_locations = self.user_locations.where('created_at >= ?', 1.year.ago).order('created_at DESC')
    total = 0
    prior_location = nil
    last_location_used = nil
    prior_locations.each do |user_location|
      user_location.same_as_home_location = (self.home_location && user_location.location.city_name == self.home_location.city_name && user_location.location.state_name == self.home_location.state_name)
      user_location.same_day_checkin = (prior_location && prior_location.created_at.to_date === user_location.created_at.to_date)
      user_location.used_in_total_calculation = (((!prior_location || !prior_location.same_day_checkin) && !user_location.same_day_checkin) && !user_location.same_as_home_location) ||
          (prior_location && prior_location.same_as_home_location)
      if (user_location.used_in_total_calculation)
        total += user_location.calculate_days_traveled(last_location_used)
        last_location_used = user_location
      end
      prior_location = user_location
    end
    total
  end

  def notification_preferences
    current_preferences = self.preferences.where(type_name: 'notification_preference')
    if current_preferences.count < 4
      notifications = NOTIFICATION_PREFERENCES
      notifications.each do |notification|
        current_preferences << self.preferences.create(name: notification, value: true, type_name: "notification_preference")
      end
    end
    current_preferences
  end

  def notification_email_contacts
    self.notification_contact_details.select{ |x| x.type == "EmailNotificationDetail"}
  end

  def notification_sms_contacts
    self.notification_contact_details.select{ |x| x.type == "SmsNotificationDetail"}
  end

  def send_sms_notifications(user_location)
    smss = []
    if (okay_to_send_sms?)
      self.twilio_errors ||= []
      @client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
      body = user_location.message
      from = SMS_PHONE_NUMBER
      user_location.sent_snapshot[:smss] = {}
      final_notifications = self.notification_sms_contacts.to_a.select{ |x| x.enabled_to_send_notification }
      sms_user_friends = self.friends.select { |user_friend| user_friend if user_friend.send_sms == true }
      sms_user_friends.each do |user_friend|
        user = user_friend.user
        final_notifications << SmsNotificationDetail.new(enabled_to_send_notification: true, name: user.user_name, value: user.phone) unless user.phone.blank?
      end
      final_notifications.each do |notification_contact|
        if (notification_contact.enabled_to_send_notification)
          begin
            @client.account.sms.messages.create(
              :from => from,
              :to => "#{notification_contact.value}",
              :body => body
            )
            smss << {name: notification_contact.name, value: notification_contact.value}
          rescue Exception => e
            self.twilio_errors << e
          end
        end
      end
    end
    user_location.sent_snapshot[:smss] = smss
  end

  def send_email_notifications(user_location)
    emails = []
    if (okay_to_send_email?)
      final_notifications = self.notification_email_contacts.to_a.select{ |x| x.enabled_to_send_notification }
      email_user_friends = self.friends.select { |user_friend| user_friend if user_friend.send_email == true }
      email_user_friends.each do |user_friend|
        user = user_friend.user
        final_notifications << EmailNotificationDetail.new(enabled_to_send_notification: true, name: user.user_name, value: user.email)
      end
      final_notifications.each do |notification_contact|
        if (notification_contact.enabled_to_send_notification)
          NotificationMailer.delay.arrival_email(user_location, notification_contact)
          emails << {name: notification_contact.name, value: notification_contact.value}
        end
      end
    end
    user_location.sent_snapshot[:emails] = emails
  end

  def post_to_facebook(user_location)
    user_location.sent_snapshot[:facebook] = false
    if (okay_to_send_facebook? && provider('facebook'))
      @graph = Koala::Facebook::API.new(provider('facebook').provider_token)
      post_text = []
      place_info = "#{user_location.message}"
      # post_text << "    "
      post_text << place_info
      description = "Have first hand knowledge of #{user_location.location.city_state_country}? What should #{user_name} do and who should they meet?"
      link = user_location.user_location_url_safe(self)
      begin
        result = @graph.put_connections("me",
          "feed?message=#{post_text.join("\n")}&description=#{description}&link=#{link}&picture=http://www.ohheyworld.com/assets/OHWicon.jpeg")
        user_location.sent_snapshot[:facebook_perma_link] = "http://facebook.com/#{result["id"]}"
        user_location.sent_snapshot[:facebook] = true
      rescue Koala::Facebook::APIError => exc
        case exc.fb_error_code
          when 200 #can't post
            self.provider('facebook').update_attributes(failed_post_deauthorized: true, failed_app_deauthorized: false)
          when 190 #app deauthorized
            self.provider('facebook').update_attributes(failed_app_deauthorized: true)
        end
      end
    end
  end

  def post_to_twitter(user_location)
    user_location.sent_snapshot[:twitter] = false
    begin
      if (okay_to_send_twitter? && provider('twitter'))
        @client = Twitter::Client.new(
          :oauth_token => provider('twitter').provider_token,
          :oauth_token_secret => provider('twitter').secret
        )
        body = user_location.message
        #TODO check for rate limit or other failure
        result = @client.update(body)
        perma_link = "https://twitter.com/#{provider('twitter').nickname}/statuses/#{result.id}"
        user_location.sent_snapshot[:twitter_perma_link] = perma_link
        user_location.sent_snapshot[:twitter] = true
      end
    rescue Exception => e
      Rails.logger.info e
    end
  end

  def okay_to_send_facebook?
    okay_to_send?(provider_valid_enabled_authorized?('facebook'), :facebook_override, "facebook", provider_authorized?('facebook'))
  end

  def okay_to_send_twitter?
    okay_to_send?(provider_valid_enabled_authorized?('twitter'), :twitter_override, "twitter", provider_authorized?('twitter'))
  end

  def okay_to_send_sms?
    okay_to_send?(provder_enabled?('sms_friends'), :sms_override, "sms_friends", provder_enabled?('sms_friends'))
  end

  def okay_to_send_email?
    okay_to_send?(provder_enabled?('email_friends'), :email_override, "email_friends", provder_enabled?('email_friends'))
  end

  def okay_to_send?(provider_authorized_enabled, override_name, provider_name, provider_authorized)
    send_override = send_overrides[override_name.to_s]
    ((send_override == true &&  provider_authorized?(provider_name)) || (send_override == nil && provider_authorized_enabled))
  end

  def email_followers_want_checkin(user_location)
    users = check_followers_want_notification(user_location, 'email_close_following')
    emails = []
    users.each do |user|
      NotificationMailer.delay.arrival_email(user_location, NotificationContactDetail.new(name: user.user_name, value: user.email)) unless emails.include?(user.email)
      emails << user.email
    end
  end

  def sms_followers_want_checkin(user_location)
    users = check_followers_want_notification(user_location, 'sms_close_following')
    self.twilio_errors ||= []
    smss = []
    @client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
    body = "#{user_location.user.user_name} just checked in to #{user_location.location.name}"
    from = SMS_PHONE_NUMBER
    users.each do |user|
      if user.phone && !smss.include?(user.phone)
        begin
          @client.account.sms.messages.create(
            :from => from,
            :to => user.phone,
            :body => body
          )
        rescue Exception => e
          self.twilio_errors << e
        end
      end
      smss << user.phone
    end
  end

  def check_followers_want_notification(user_location, preference_name)
    where = 'user_friends.friend_id = :user_id AND preferences.name = :preference_name AND (preferences.value = :one_value OR preferences.value = :true_value)'
    params = {user_id: self.id, preference_name: preference_name, one_value: '1', true_value: true}
    location = user_location.location
    User.select('DISTINCT users.*').joins(:user_friends, :preferences, :user_locations => :location).within(DEFAULT_RADIUS, :origin => [location.latitude, location.longitude]).where(where, params)
  end

  def check_send_matching_users_tags_at_location(user_location)
    matching_tags = UserTagNotification.users_with_tag_at_location(self, self.user_tag_notifications.map(&:tag), user_location.location)
    email_notifications =  user_tag_notifications.select{ |x| x.email == true && matching_tags.keys.include?(x.tag) && matching_tags[x.tag].length > 0 }
    sms_notifications = user_tag_notifications.select{ |x| x.email == true && matching_tags.keys.include?(x.tag) && matching_tags[x.tag].length > 0 }
    if (email_notifications.count > 0 && matching_tags && matching_tags.count > 0)
      NotificationMailer.delay.ohw_users_with_same_interest_location(user_location, matching_tags.map{ |x| x[0] if x[1].all.count > 0 }.compact.join(', '))
    end
    if (sms_notifications)
      self.twilio_errors ||= []
      @client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
      body = "We found people that share your interests in #{user_location.location.name}"
      from = SMS_PHONE_NUMBER
      begin
        @client.account.sms.messages.create(
          :from => from,
          :to => self.phone,
          :body => body
        )
      rescue Exception => e
        self.twilio_errors << e
      end
    end
  end

  def post_notifications(user_location)
    #do the tag search
    #check_send_matching_users_tags_at_location(user_location)
    unless user_location.private
      email_followers_want_checkin(user_location)
      sms_followers_want_checkin(user_location)
    end
    user_location.sent_snapshot = {}
    attempt(1) { post_to_facebook(user_location) }
    attempt(1) { post_to_twitter(user_location) }
    attempt(1) { send_email_notifications(user_location) }
    attempt(1) { send_sms_notifications(user_location) }
    user_location.save
    self.update_attribute(:send_overrides, nil)
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def is_allowed_content_creation?
    roles.include?('admin') || roles.include?('content_creator')
  end

  def make_admin
    self.roles = ['admin', 'standard', 'content_creator']
    self.save
  end

  def import_facebook_friends
    facebook_provider = provider('facebook')
    update_attribute(:import_job_finished_at, nil)
    job = Delayed::Job.enqueue(ImportFacebookFriends.new({user: self, provider: facebook_provider}))
    update_attribute(:import_job_id, job.id)
  end

  def import_job_working?
    import_job_id.present?
  end

  def import_job_finished?
    import_job_finished_at.present?
  end

  def unique_tags
    unique_user_friend_tags = Tag.unique_model_tags(id, 'UserFriend', 'user_id')
    unique_user_friend_provider_tags = Tag.unique_model_tags(id, 'UserProviderFriend', 'user_id')
    unique_friend_tags = unique_user_friend_tags + unique_user_friend_provider_tags
    unique_friend_tags.uniq!
    add_required_tags(unique_friend_tags)
    unique_friend_tags
  end

  def add_required_tags(unique_friend_tags)
    add_required_tag(unique_friend_tags, 'Family')
    add_required_tag(unique_friend_tags, 'Close Friends')
  end

  def add_required_tag(unique_friend_tags, name)
    unique_friend_tags << Tag.new(name: name) unless unique_friend_tags.select{ |x| x.name == name}.count == 1
  end

  class << self

    def user_with_ids(ids, page)
      User.where('id IN (?)', ids).page(page)
    end

    def users_at_location(location, user, page_override, current="t", page)
      return User.none.page(page) unless user && location
      subquery = %q(
      	(SELECT
        	provider_friends.user_id
        FROM
        	provider_friends
        	INNER JOIN user_provider_friends ON user_provider_friends.provider_friend_id = provider_friends.id
        WHERE
        	provider_friends.user_id IS NOT NULL AND user_provider_friends.user_id = :user_id))
      where_clause = "(user_locations.current = :current AND users.id != :user_id AND user_locations.private = false AND users.id NOT IN (SELECT friend_id FROM user_friends WHERE user_id = :user_id) AND users.id NOT IN #{subquery})"
      params = {current: current, user_id: user.id}
      results = User.joins(:user_locations => :location).within(DEFAULT_RADIUS, :origin => [location.latitude, location.longitude]).where(where_clause, params)
        #.group('users.id,locations.latitude,locations.longitude')
      (page_override) ? results.limit(25) : results.page(page).per_page(12)
    end

    def users_at_location_ohw_friends(location, user, page)
      User.joins(:user_friends, :user_locations => :location).where('users.id = ?', user.id).within(DEFAULT_RADIUS, :origin => [location.latitude, location.longitude]).page(page)
    end

    def users_at_location_friends(location, user, current="t", page)
      where_clause = "user_locations.current = :current AND users.id != :user_id AND provider_friends.user_id IS NOT NULL"
      params = {current: true, user_id: user.id}
      user_provider_joins = "LEFT JOIN user_provider_friends ON user_provider_friends.user_id = users.id"
    	provider_friend_join = "LEFT JOIN provider_friends ON provider_friends.id = user_provider_friends.provider_friend_id"
      results = User.joins(user_provider_joins).joins(provider_friend_join).joins(:user_locations => :location).within(DEFAULT_RADIUS, :origin => [location.latitude, location.longitude]).where(where_clause,
          params).group('users.id,locations.latitude,locations.longitude').page(page)
    end

    def check_registration(email)
      beta_user = BetaUser.find_by_email(email)
      register = false
      if beta_user
        register = true
      else
        registration_code = RegistrationCode.find_valid_registration_code(code)
        if registration_code
          registration_code.update_attribute(:uses, registration_code.uses - 1)
          register = true
        end
      end
      register
    end

    def find_for_facebook_oauth(access_token, signed_in_resource=nil)
      data = access_token['extra']['raw_info']
      email = data["email"]
      user = User.find_by_email(email)
      if (!user || !user.provider_valid?('facebook')) #check beta status
        if !user
          user = User.create_with_provider_profile(access_token, user)
        elsif(user)
          user_provider = user.provider('facebook')
          if user_provider
            user_provider.save_facebook(access_token)
          else
            User.create_with_provider_profile(access_token, user)
          end
        end
      else
        user_provider = user.provider('facebook')
        user_provider.update_attributes(provider_token: access_token['credentials']['token'])
      end
      user
    end

    def find_for_twitter_oauth(access_token, code, signed_in_resource=nil)
      data = access_token['extra']['raw_info']
      nickname = data['info']['name']
      provider_name = data['provider']
      user_provider = UserProvider.registered_user(provider_name, data['uid'])
      user = user_provider.user if user_provider
      if !user || !user.provider_valid?(provider_name) #check beta status
        if !user
          user = User.create_with_provider_profile(access_token, user)
        elsif(user)
          user_provider = user.provider(provider_name)
          if user_provider
            user_provider.save_facebook(access_token)
          end
        end
      end
      user
    end

    def save_friends(oauth_access_token, provider_name, user)
      provider_friends =[]
      @graph = Koala::Facebook::API.new(oauth_access_token)
      #update friends
      friends = @graph.get_connections("me", "friends", fields: "name,id,username,picture,link,location")
      friends.each do |friend|
        friend_id = friend["id"]
        registered_user = UserProvider.registered_user('facebook', friend_id)
        provider_friend = ProviderFriend.find_or_initialize_by_uid(friend_id)
        provider_friend.provider_name = provider_name
        provider_friend.user_name = friend["name"]
        provider_friend.username = friend["username"]
        provider_friend.user_id = registered_user.user.id if registered_user
        picture_url = ["http://graph.facebook.com", friend_id, "picture"].join("/")
        provider_friend.picture_url = picture_url
        provider_friend.link = friend["link"]
        location_info = friend["location"]["name"] if friend["location"]
        unless location_info.blank?
          provider_friend.location = Location.find_or_create_by_user_input(location_info)
        end
        provider_friend.save
        UserProviderFriend.find_or_create_by_user_id_and_provider_friend_id(user_id: user.id, provider_friend_id: provider_friend.id)
        provider_friends << provider_friend
      end
      provider_friends
    end

    def create_with_client(params)
      unless params[:home_location].blank?
        home_town_location = Location.find_or_create_by_user_input(params[:home_location])
        params[:home_town_location_id] = home_town_location.id
      end

      residence_location = params[:residence_location]
      params.delete(:residence_location)
      params.delete(:home_location)
      params.delete(:id)
      params.delete(:roles_mask)
      params.delete(:slug)
      params.delete(:updated_at)
      params.delete(:created_at)

      user = User.create!(params.merge(password: Devise.friendly_token[0,20]))

      unless residence_location.blank?
        currently_lives_in = Location.find_or_create_by_user_input(params[:residence_location])
        user_location = UserLocation.find_or_create_by_user_id_and_location_id_and_residence(
          user_id: user.id,
          location_id: currently_lives_in.id,
          residence: true)
      end
      user
    end

    def create_with_provider_profile(access_token, user)
      token = access_token['credentials']['token']
      data = access_token['extra']['raw_info']
      provider_token_timeout = access_token['credentials']['expires_at']
      location = access_token["info"]["location"]
      full_name = access_token["info"]["name"]
      username = data[:username]
      username = full_name.gsub(/\s+/, "") if username.blank?
      picture_url = ["http://graph.facebook.com", access_token.uid, "picture"].join("/")
      birthday = Chronic::parse(data["birthday"])
      home_town_name = nil
      home_town_location = nil
      if data["hometown"]
        home_town_name = data["hometown"]["name"]
        home_town_location = Location.find_or_create_by_user_input(home_town_name)
        home_town_location_id = home_town_location.id
      end

      params = {email: data["email"], first_name: data["first_name"], last_name: data["last_name"],
        gender: data["gender"],  timezone: data["timezone"], locale: data["locale"],
        picture_url: picture_url, link: data["link"], home_town_location_id: home_town_location_id,
        nickname: username, birthday: birthday}

      if user && user.persisted?
        params.delete(:nickname)
        user.update_attributes(params)
      else
        user = User.new(params.merge(password: Devise.friendly_token[0,20]))
        user.skip_confirmation!
        user.save!
      end

      if location
        currently_lives_in = Location.find_or_create_by_user_input(location)
        user_location = UserLocation.find_or_create_by_user_id_and_location_id_and_residence(
          user_id: user.id,
          location_id: currently_lives_in.id,
          residence: true)
      end
      user_provider = UserProvider.find_or_initialize_by_provider_and_user_id(user_id: user.id, provider: access_token.provider)
      user_provider.save_facebook(access_token)
      user.user_providers << user_provider unless user.user_providers.first
      user
    end

    def slugged(page=1)
      User.where('slug is not null').page(page)
    end

    def by_tag_all_users(search_tags, page=1, wild=false)
      User.tagged_with(search_tags, wild: wild).page(page)
    end

    def by_tag(current_user, search_tags, page=1, wild=false)
      User.where('users.id != ?', current_user.id).tagged_with(search_tags, wild: wild).page(page)
    end

    def by_wild_tag(current_user, search_tags, page=1)
      User.where('users.id != ?', current_user.id).tagged_with(search_tags, any: true, wild: true).page(page)
    end

    def by_tags_at_location(user, location, page=1)
      return User.none.page(page) unless user && location
      User.users_with_tag_at_location(user, user.interest_list, location, page)
    end

    def users_with_tag_at_location(user, tags, location, page=1)
      return User.none.page(page) unless user && location
      User.joins(:user_locations => :location).where('users.id != ? AND (user_locations.current = true AND user_locations.private = false)', user.id).tagged_with(tags, :any => true).within(DEFAULT_RADIUS, :origin => [location.latitude, location.longitude]).group('users.id,locations.latitude,locations.longitude').page(page)
    end

    def preference_true?(name, value)
      [true, 1, "1", "t", "On", "true"].include?(value)
    end

    def with_tips_for_city(city_id, page=1)
      User.select('DISTINCT users.*').joins(:user_cities => :user_city_tips).where('city_id = ?', city_id).page(page)
    end

    def closest_with_tags(current_user, list, page=1)
      users = nil
      if current_user
        user_location = current_user.current_location
        if user_location
          location = user_location.location
          users = User.select('DISTINCT users.*').joins(user_locations: :location).where('user_locations.current = true').closest(origin: [location.latitude, location.longitude]).by_tag(current_user, list, page).limit(12)
        else
          users = User.select('DISTINCT users.*').by_tag(current_user, list, page)
        end
      else
        users = User.select('DISTINCT users.*').by_tag_all_users(list, page)
      end
      users
    end
  end
end
