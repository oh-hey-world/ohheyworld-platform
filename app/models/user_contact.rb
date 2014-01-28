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

class UserContact < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact, :class_name => "User", :foreign_key => "contact_id"

  attr_accessible :contact_id, :email, :message, :phone, :subject, :user_id
end
