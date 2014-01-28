class AddEnabledToSendToNotificationContactDetail < ActiveRecord::Migration
  def change
    add_column :notification_contact_details, :enabled_to_send_notification, :boolean, default: true

  end
end
