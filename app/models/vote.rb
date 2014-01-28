# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  votable_id   :integer
#  votable_type :string(255)
#  voter_id     :integer
#  voter_type   :string(255)
#  vote_flag    :boolean
#  vote_scope   :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Vote < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :user
  belongs_to :user_location, class_name: "UserLocation", foreign_key: "votable_id"

  class << self
    def check_send_notifications(user_location, voter)
      if (user_location.user.email_for_like)
        NotificationMailer.send_checkin_vote(user_location, voter).deliver
      end
      true
    end
  end
end
