# == Schema Information
#
# Table name: user_contacts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  contact_id :integer
#  subject    :string(255)
#  message    :text
#  email      :string(255)
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe UserContact do
  pending "add some examples to (or delete) #{__FILE__}"
end
