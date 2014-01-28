# == Schema Information
#
# Table name: user_locations
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  location_id    :integer
#  current        :boolean          default(FALSE)
#  ended_at       :datetime
#  residence      :boolean
#  slug           :string(255)
#  name           :string(255)
#  sent_snapshot  :text
#  custom_message :text
#  source         :string(255)
#  private        :boolean          default(FALSE)
#

class UserLocation < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :location
  has_many :notification_contact_details, through: :user
  has_many :user_location_assets, :dependent => :destroy
  has_many :user_location_notes, :dependent => :destroy
  has_many :user_location_tagged_users, :dependent => :destroy
  before_validation :save_or_set_location
  before_save :set_name, :make_current_and_all_prior_non_current
  accepts_nested_attributes_for :location

  attr_accessible :ended_at, :user_id, :created_at, :updated_at, :location_id, :current, :location_attributes, :residence,
    :name, :sent_snapshot, :location, :custom_message, :source, :user_location_assets_attributes, :private, :tag_list
  attr_accessor :same_as_home_location, :same_day_checkin, :used_in_total_calculation, :prior_location_id

  acts_as_votable
  acts_as_commentable
  acts_as_taggable

  accepts_nested_attributes_for :user_location_assets, :allow_destroy => true

  self.include_root_in_json = true

  serialize :sent_snapshot, Hash

  self.per_page = 10

  extend FriendlyId
  friendly_id :name_and_date, use: :slugged

  default_scope includes(:location)
  default_scope includes(:user)

  def after_initialize
    sent_snapshot |= {}
  end

  def just_created
    (((Time.now.utc - created_at) * 24 * 60 * 60).to_i < 60)
  end

  def posts?
    (posted_to_twitter? || posted_to_facebook? || (sent_snapshot[:smss] && sent_snapshot[:smss].count > 0) || (sent_snapshot[:emails] && sent_snapshot[:emails].count > 0))
  end

  def posted_to_facebook?
    posted_to_provider?(:facebook)
  end

  def posted_to_twitter?
    posted_to_provider?(:twitter)
  end

  def posted_to_provider?(provider)
    (sent_snapshot[provider] && sent_snapshot[provider] == true)
  end

  def should_generate_new_friendly_id?
    new_record?
  end

  def set_name
    self.name = location.name if ((new_record? || self.name.blank?) && location)
  end

  def message
    place_info = nil
    unless (custom_message.blank?)
      place_info = "#{custom_message} - in #{location.name}"
    else
      place_info = "#{user.first_name} arrived safely in #{location.name}"
    end
    link = user_location_url_safe(user)
    place_info << " #{created_at.strftime("%b, %d")}\n"
    place_info << "#{link}\n"
    place_info
  end

  def user_location_url_safe(user)
    user_user_location_url(user, self).gsub("localhost:3000", "www.ohheyworld.com")
  end

  def name_and_date
    the_time = (created_at) ? created_at : Time.now
    the_name = (name.blank? && location) ? location.name : name
    "#{the_name} #{the_time.strftime("%B %d %Y")}"
  end

  def make_current_and_all_prior_non_current
    return_value = true
    if self.location
      if new_record?
        user.update_attributes(completed_first_checkin: true) unless user.completed_first_checkin
        most_recent_place = user.most_recent_place
        if (!created_at || (most_recent_place && most_recent_place.location && created_at > most_recent_place.created_at))
          if (most_recent_place && most_recent_place.location && most_recent_place.location.city_name == location.city_name && most_recent_place.location.state_name == location.state_name &&
            !(most_recent_place.residence == true && location.residence != true))
            self.prior_location_id = most_recent_place.id
            return_value = false
          else
            UserLocation.where(user_id: self.user.id, current: true).where("user_locations.id IS NOT NULL").update_all(current: false)
            self.current = true
          end
        end
      end
    else
      return_value = false
    end
    return_value
  end

  def save_or_set_location
    if location && !location.id
      self.location = Location.find_or_create_by_user_input(location.user_input)
    end
  end

  def calculate_days_traveled(prior_location)
    current_ended_at = (self.ended_at) ? self.ended_at : Time.now
    days_travelled = (current_ended_at.end_of_day - self.created_at.beginning_of_day).to_i / 1.day
    if (prior_location && prior_location.created_at.to_date === current_ended_at.to_date)
      days_travelled -= 1
    end
    days_travelled
  end

  def allowed_comments(signed_in_user, creation_user)
    root_comments.where('user_id in (?) OR private = false', [signed_in_user, creation_user])
  end

  class << self
    def checkins(page)
      UserLocation.order('user_locations.created_at DESC').page(page)
    end

    def append_current_time_to_date(date)
      date = Chronic.parse("#{date} #{Time.now.strftime("%H:%M:%S")}") unless date.blank?
    end

    def locations_user_friends(user, page)
      UserLocation.where(private: false, user_id: UserFriend.user_friends_ids(user)).page(page).order('user_locations.created_at DESC')
    end

    def locations_user_friends_by_tag(user, tag, page)
      UserLocation.where(private: false, user_id: UserFriend.user_friends_by_tag_ids(user, tag)).page(page).order('user_locations.created_at DESC')
    end

    def ohw_network(current_user, page=1)
      UserLocation.where('user_id != ? AND (private = ? OR private IS NULL) AND (residence = ? OR residence IS NULL)', current_user.id, false, false).order('user_locations.created_at DESC').page(page)
    end
  end
end
