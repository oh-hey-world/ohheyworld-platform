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

class UserLocationAsset < ActiveRecord::Base
  belongs_to :user_location

  has_attached_file :asset,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :default_url => '/assets/no_image.jpg',
                    :url => ':s3_domain_url',
                    :path => 'assets/:class/:id/:style.:extension',
                    :styles => {:thumb => 'x100'}

  validates_attachment_presence :asset
  validates_attachment_size :asset, :less_than => 5.megabytes

  attr_accessible :asset, :user_id, :created_at, :updated_at, :type, :default, :asset_file_size, :user_location_id

  def asset_url
    asset.url
  end
end
