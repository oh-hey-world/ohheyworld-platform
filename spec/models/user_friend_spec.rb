# == Schema Information
#
# Table name: user_friends
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  send_sms   :boolean          default(FALSE)
#  send_email :boolean          default(FALSE)
#  phone      :string(255)
#

require 'spec_helper'

describe UserFriend do
  pending "add some examples to (or delete) #{__FILE__}"
end
