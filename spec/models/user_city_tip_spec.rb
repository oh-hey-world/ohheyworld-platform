# == Schema Information
#
# Table name: user_city_tips
#
#  id             :integer          not null, primary key
#  tip            :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_city_id   :integer
#  travel_profile :string(255)
#  link_name      :string(255)
#  link_value     :string(255)
#

require 'spec_helper'

describe UserCityTip do
  pending "add some examples to (or delete) #{__FILE__}"
end
