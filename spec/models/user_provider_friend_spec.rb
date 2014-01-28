# == Schema Information
#
# Table name: user_provider_friends
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  provider_friend_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  following          :boolean
#  email              :string(255)
#  phone              :string(255)
#

require 'spec_helper'

describe UserProviderFriend do
  pending "add some examples to (or delete) #{__FILE__}"
end
