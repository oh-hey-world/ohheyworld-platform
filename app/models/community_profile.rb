# == Schema Information
#
# Table name: community_profiles
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  community_id :integer
#  tagline      :text
#  answer       :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  admin        :boolean          default(FALSE)
#  custom_field :string(255)
#

class CommunityProfile < ActiveRecord::Base
  attr_accessible :answer, :community_id, :community, :user, :tagline, :user_id, :admin, :custom_field

  belongs_to :user
  belongs_to :community

  validates :answer, presence: true

  def to_param
    self.user.slug
  end

  def self.find_by_param(parent_param, param)
    members = Community.find_by_param(parent_param).community_profiles
    members.find_by_user_id(User.find_by_slug(param))
  end
end
