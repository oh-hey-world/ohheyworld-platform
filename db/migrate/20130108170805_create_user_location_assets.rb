class CreateUserLocationAssets < ActiveRecord::Migration
  def change
    create_table :user_location_assets do |t|
      t.integer :user_id

      t.timestamps
    end

    add_column :user_location_assets, :asset_file_name, :string
    add_column :user_location_assets, :asset_content_type, :string
    add_column :user_location_assets, :asset_file_size, :integer
    add_column :user_location_assets, :asset_updated_at, :datetime
    add_column :user_location_assets, :type, :string
    add_column :user_location_assets, :default, :boolean
  end
end
