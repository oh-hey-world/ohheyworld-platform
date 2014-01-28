class RemoveCounterToUserAsset < ActiveRecord::Migration
  def up
    remove_column :user_assets, :user_assets_count
  end

  def down
  end
end
