# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state_id   :integer
#  country_id :integer
#  slug       :string(255)
#

require 'spec_helper'

describe City do
  pending "add some examples to (or delete) #{__FILE__}"
end
