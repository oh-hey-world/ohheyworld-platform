class CreateUserLocationTaggedUsers < ActiveRecord::Migration
  def change
    create_table :user_location_tagged_users do |t|
      t.integer :user_id
      t.integer :provider_friend_id
      t.integer :user_location_id
      t.string :type

      t.timestamps
    end
  end
end
