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

require 'spec_helper'

describe RegistrationCode do
  pending "add some examples to (or delete) #{__FILE__}"
end
