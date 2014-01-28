# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer          default(0)
#  commentable_type :string(255)      default("")
#  title            :string(255)      default("")
#  body             :text             default("")
#  subject          :string(255)      default("")
#  user_id          :integer          default(0), not null
#  parent_id        :integer
#  lft              :integer
#  rgt              :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  link_name        :string(255)
#  link_value       :string(255)
#  private          :boolean          default(FALSE)
#

class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  serialize :links, Hash

  validates_presence_of :body
  validates_presence_of :user
  validates :link_value, format: URI::regexp(%w(http https)), allow_blank: true

  attr_accessible :commentable_id, :commentable_type, :title, :body, :subject,
    :user_id, :parent_id, :lft, :rgt, :created_at, :updated_at, :link_name, :link_value, :private

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  belongs_to :commentable, :polymorphic => true

  # NOTE: Comments belong to a user
  belongs_to :user
  belongs_to :user_location, class_name: "UserLocation", foreign_key: "commentable_id"

  after_commit :check_send_notifications, on: :create

  def check_send_notifications
    if (commentable_type == "UserLocation" && user_location.user.email_for_comment)
      NotificationMailer.send_checkin_comment(user_location, self).deliver
    end
  end

  acts_as_votable

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    c = self.new
    c.commentable_id = obj.id
    c.commentable_type = obj.class.base_class.name
    c.body = comment
    c.user_id = user_id
    c
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.size > 0
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  class << self
  end
end
