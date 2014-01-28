class RemoveFalseToUserFriend < ActiveRecord::Migration
  def up
    change_column :user_friends, :send_sms, :boolean
    change_column :user_friends, :send_email, :boolean
  end

  def down
  end
end
