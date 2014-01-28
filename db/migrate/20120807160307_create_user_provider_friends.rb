class CreateUserProviderFriends < ActiveRecord::Migration
  def change
    create_table :user_provider_friends do |t|
      t.integer :user_id
      t.integer :provider_friend_id

      t.timestamps
    end
  end
end
