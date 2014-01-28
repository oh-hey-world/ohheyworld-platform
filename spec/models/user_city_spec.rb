# == Schema Information
#
# Table name: user_cities
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  city_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_city_tips_count :integer
#  summary              :text
#

require 'spec_helper'

describe UserCity do
  pending "add some examples to (or delete) #{__FILE__}"
end
