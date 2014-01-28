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

class EmailNotificationDetail < NotificationContactDetail
  def initialize( params={} )
    super( params.merge( :name => 'EmailNotificationDetail' ) )
  end
end
