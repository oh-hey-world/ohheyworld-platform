class CreateProviderFriends < ActiveRecord::Migration
  def change
    create_table :provider_friends do |t|
      t.string :provider_name
      t.string :user_name
      t.string :uid
      t.string :picture_url
      t.string :location_city
      t.string :location_state

      t.timestamps
    end
  end
end
