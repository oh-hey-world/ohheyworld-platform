class AddLocationToProviderFriend < ActiveRecord::Migration
  def change
    add_column :provider_friends, :location_id, :integer
    remove_column :provider_friends, :location_city
    remove_column :provider_friends, :location_state
  end
end
