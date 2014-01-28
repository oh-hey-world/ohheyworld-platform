# == Schema Information
#
# Table name: notification_contact_details
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  value                        :string(255)
#  type                         :string(255)
#  user_id                      :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  enabled_to_send_notification :boolean          default(TRUE)
#

class NotificationContactDetail < ActiveRecord::Base
  belongs_to :users
  validates_format_of :value,
   :with => /^([a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]|\+?[0-9][0-9][0-9]?[\-|\s|\.]?\(?[0-9]{3}[\-|\s|\.]?[0-9]{4})$/,
   :message => "is not a valid phone number (incl. area code) or email address"
  validates_uniqueness_of :value, :scope => [:user_id]
  before_save :set_type_by_format
  
  attr_accessible :name, :value, :type, :user_id, :enabled_to_send_notification
  attr_accessor :placeholder_name, :placeholder_value
  
  def set_type_by_format
    self.type = (self.value =~ /^[1]?[\-|\s|\.]?\(?[0-9]{3}\)?[\-|\s|\.]?[0-9]{3}[\-|\s|\.]?[0-9]{4}$/) ? 'SmsNotificationDetail' : 'EmailNotificationDetail' if self.type.blank?
  end
end
