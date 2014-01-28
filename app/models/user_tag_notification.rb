# == Schema Information
#
# Table name: user_tag_notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  tag        :string(255)
#  sms        :boolean
#  email      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserTagNotification < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :tag, :allow_blank => false,
            :allow_nil => false
  validates_uniqueness_of :tag, :scope => :user_id,
                          :case_sensitive => false

  #acts_as_mappable :through => { :user => { :user_locations => :location } }

=begin
  scope :tagged_with, lambda { |tag|
    {
      :joins => "INNER JOIN taggings ON taggings.taggable_id = users.id\
                   INNER JOIN tags ON tags.id = taggings.tag_id AND taggings.taggable_type = 'User'",
      :conditions => ["tags.name = ?", tag]
    }
  }
=end

  class << self
    def users_with_tag_at_location(user, tags, location, page=1)
      user_tag_notifications ={}
        tags.each do |tag|
          users = User.users_with_tag_at_location(user, tag, location, page)
          user_tag_notifications[tag] = users
        end
      user_tag_notifications
    end
  end
end
