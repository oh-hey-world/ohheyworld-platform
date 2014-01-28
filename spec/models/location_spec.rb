# == Schema Information
#
# Table name: locations
#
#  id           :integer          not null, primary key
#  latitude     :float
#  longitude    :float
#  address      :string(255)
#  city_name    :string(255)
#  state_name   :string(255)
#  state_code   :string(255)
#  postal_code  :string(255)
#  country_name :string(255)
#  country_code :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_input   :string(255)
#  residence    :boolean
#  state_id     :integer
#  country_id   :integer
#  city_id      :integer
#

require 'spec_helper'

describe Location do
  it "returns Louisville, KY location" do
    #user_input = 
    location = Location.find_or_create_by_user_input("Louisville, KY")
    location.should_not be_nil
  end
end
