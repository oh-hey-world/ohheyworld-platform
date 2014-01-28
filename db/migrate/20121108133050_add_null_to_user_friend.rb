class AddNullToUserFriend < ActiveRecord::Migration
  def change
    change_column :user_friends, :send_sms, :boolean, :default => false
    change_column :user_friends, :send_email, :boolean, :default => false
  end
end
