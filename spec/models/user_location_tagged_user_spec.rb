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

require 'spec_helper'

describe UserLocationTaggedUser do
  pending "add some examples to (or delete) #{__FILE__}"
end
