# == Schema Information
#
# Table name: user_assets
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  asset_file_name    :string(255)
#  asset_content_type :string(255)
#  asset_file_size    :integer
#  asset_updated_at   :datetime
#  type               :string(255)
#  default            :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe UserAsset do
  pending "add some examples to (or delete) #{__FILE__}"
end
