# == Schema Information
#
# Table name: user_locations
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  location_id    :integer
#  current        :boolean          default(FALSE)
#  ended_at       :datetime
#  residence      :boolean
#  slug           :string(255)
#  name           :string(255)
#  sent_snapshot  :text
#  custom_message :text
#  source         :string(255)
#  private        :boolean          default(FALSE)
#

require 'spec_helper'

describe UserLocation do

end
