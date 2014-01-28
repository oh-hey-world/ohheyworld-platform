class AddUserLocationIdToUserLocationAsset < ActiveRecord::Migration
  def change

    add_column :user_location_assets, :user_location_id, :integer

  end
end
