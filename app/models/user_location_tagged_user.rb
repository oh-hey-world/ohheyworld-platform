# == Schema Information
#
# Table name: user_location_tagged_users
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  provider_friend_id :integer
#  user_location_id   :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class UserLocationTaggedUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :provider_friend
  belongs_to :user_location

  attr_accessible :user_id, :provider_friend_id, :user_location_id
  attr_accessor :friend_name, :link
end
