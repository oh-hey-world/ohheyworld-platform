class AddPhoneToUserFriend < ActiveRecord::Migration
  def change
    add_column :user_friends, :phone, :string

  end
end
