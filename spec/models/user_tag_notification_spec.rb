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

require 'spec_helper'

describe UserTagNotification do
  pending "add some examples to (or delete) #{__FILE__}"
end
