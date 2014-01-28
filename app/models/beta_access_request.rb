# == Schema Information
#
# Table name: beta_access_requests
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BetaAccessRequest < ActiveRecord::Base
  validates_format_of :email, :with =>
    /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :email, :presence => true, :uniqueness => true

  attr_accessible :email
end
