# == Schema Information
#
# Table name: user_location_assets
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  asset_file_name    :string(255)
#  asset_content_type :string(255)
#  asset_file_size    :integer
#  asset_updated_at   :datetime
#  type               :string(255)
#  default            :boolean
#  user_location_id   :integer
#

require 'spec_helper'

describe UserLocationAsset do
  pending "add some examples to (or delete) #{__FILE__}"
end
