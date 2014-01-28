# == Schema Information
#
# Table name: provider_friends
#
#  id            :integer          not null, primary key
#  provider_name :string(255)
#  user_name     :string(255)
#  uid           :string(255)
#  picture_url   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  link          :string(255)
#  location_id   :integer
#  user_id       :integer
#  username      :string(255)
#  email         :string(255)
#  phone         :string(255)
#

require 'spec_helper'

describe ProviderFriend do
  pending "add some examples to (or delete) #{__FILE__}"
end
