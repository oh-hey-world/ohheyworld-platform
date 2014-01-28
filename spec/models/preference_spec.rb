# == Schema Information
#
# Table name: preferences
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  value      :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type_name  :string(255)
#

require 'spec_helper'

describe Preference do
  pending "add some examples to (or delete) #{__FILE__}"
end
