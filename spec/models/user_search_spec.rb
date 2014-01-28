# == Schema Information
#
# Table name: user_searches
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  location_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_input  :string(255)
#  tag_id      :integer
#

require 'spec_helper'

describe UserSearch do
  pending "add some examples to (or delete) #{__FILE__}"
end
