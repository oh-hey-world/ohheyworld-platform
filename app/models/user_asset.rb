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

class UserAsset < ActiveRecord::Base

  belongs_to :user
  before_save :save_all_other_not_default

  has_attached_file :asset,
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :default_url => '/assets/no_image.jpg',
    :url => ':s3_domain_url',
    :path => 'assets/:class/:id/:style.:extension',
    :styles => { :large => "x200", :medium => "x100", :small => "x50", :thumb => "50x50" }

  validates_attachment_presence :asset
  validates_attachment_size :asset, :less_than => 5.megabytes

  attr_accessible :asset, :user_id, :created_at, :updated_at, :type, :default, :id, :asset_file_size

  def asset_url
    asset.url.gsub('_photo', '')
  end

  def save_all_other_not_default
    #UserAsset.where(user_id: self.user.id, default: true).where("user_assets.id IS NOT NULL").update_all(default: false) if default
  end
end
