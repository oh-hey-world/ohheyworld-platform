class AddCounterToUserAsset < ActiveRecord::Migration
  def change
    add_column :user_assets, :user_assets_count, :integer

  end
end
