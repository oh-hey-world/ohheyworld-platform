# == Schema Information
#
# Table name: registration_codes
#
#  id              :integer          not null, primary key
#  code            :string(255)
#  uses            :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  original_amount :integer
#  description     :text
#

class RegistrationCode < ActiveRecord::Base
  before_save :set_code
  before_create :set_original_amount
  
  attr_accessible :uses, :code, :original_amount, :description
  
  def set_code
    self.code = UUIDTools::UUID.random_create.to_s if code.blank?
  end

  def set_original_amount
    self.original_amount = uses
  end

  class << self
    def find_valid_registration_code(registration_code)
      RegistrationCode.where("uses > 0 AND code = ?", registration_code).first
    end
  end

end
