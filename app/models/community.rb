# == Schema Information
#
# Table name: communities
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  question           :text
#  brand_file_name    :string(255)
#  brand_content_type :string(255)
#  brand_file_size    :integer
#  brand_updated_at   :datetime
#  community_slug     :string(255)
#  tagline            :string(255)
#  custom_field_label :string(255)
#

class Community < ActiveRecord::Base
  attr_accessible :name, :description, :question, :brand, :concerns, :concern_list, :tagline, :custom_field_label
  attr_accessor :concern_list

  acts_as_taggable
  acts_as_taggable_on :concerns

  has_many :users, through: :community_profiles
  has_many :community_profiles

  validates :name, presence: true, uniqueness: true
  validates :question, presence: true

  before_save :set_community_slug

  has_attached_file :brand, :styles => { :thumb => "50x50>" }, :default_url => "/assets/brandless.gif"

  def members
    self.community_profiles
  end

  def locations
    locations = self.community_profiles.map do |profile|
      profile.user.current_location.location.country_name if profile.user && profile.user.current_location
    end

    locations.uniq
  end

  def has_as_member?(user)
    if self.members.find_by_user_id(user.id)
      true
    else
      false
    end
  end

  def has_as_admin?(user)
    this_user = self.members.find_by_user_id(user.id)
    this_user.admin if this_user
  end


  def find_member(user)
    self.members.find_by_user_id(user.id)
  end

  #parameters

  def set_community_slug
    self.community_slug = self.name.parameterize
  end

  def self.find_by_param(param)
    find_by_community_slug(param)
  end

  def to_param
    self.community_slug
  end

end
