class AddColumnToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :location_id, :integer
  end
end
