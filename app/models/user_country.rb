# == Schema Information
#
# Table name: user_countries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserCountry < ActiveRecord::Base
  belongs_to :country
  belongs_to :user
end
