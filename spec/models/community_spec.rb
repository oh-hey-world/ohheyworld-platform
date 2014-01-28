# == Schema Information
#
# Table name: communities
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  question           :text
#  brand_file_name    :string(255)
#  brand_content_type :string(255)
#  brand_file_size    :integer
#  brand_updated_at   :datetime
#  community_slug     :string(255)
#  tagline            :string(255)
#  custom_field_label :string(255)
#

require 'spec_helper'

describe Community do
  pending "add some examples to (or delete) #{__FILE__}"
end
