class RemoveUserIdToUserLocationAsset < ActiveRecord::Migration
  def up
    remove_column :user_location_assets, :user_id
  end

  def down
  end
end
