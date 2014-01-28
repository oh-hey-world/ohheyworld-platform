class AddNotificationToUserFriend < ActiveRecord::Migration
  def change
    add_column :user_friends, :send_sms, :boolean

    add_column :user_friends, :send_email, :boolean

  end
end
