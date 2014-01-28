class RemoveUserLocationColumnsAddLocation < ActiveRecord::Migration
  def up
    remove_column :user_locations, :latitude
    remove_column :user_locations, :longitude
    remove_column :user_locations, :address
    remove_column :user_locations, :city
    remove_column :user_locations, :state
    remove_column :user_locations, :state_code
    remove_column :user_locations, :postal_code
    remove_column :user_locations, :country
    remove_column :user_locations, :country_code
    
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :city
      t.string :state
      t.string :state_code
      t.string :postal_code
      t.string :country
      t.string :country_code

      t.timestamps
    end
  end

  def down
  end
end
