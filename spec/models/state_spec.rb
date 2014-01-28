# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  link       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :integer
#  code       :string(255)
#  latitude   :float
#  longitude  :float
#

require 'spec_helper'

describe State do
  pending "add some examples to (or delete) #{__FILE__}"
end
