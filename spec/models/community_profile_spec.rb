# == Schema Information
#
# Table name: community_profiles
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  community_id :integer
#  tagline      :text
#  answer       :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  admin        :boolean          default(FALSE)
#  custom_field :string(255)
#

require 'spec_helper'

describe CommunityProfile do
  pending "add some examples to (or delete) #{__FILE__}"
end
