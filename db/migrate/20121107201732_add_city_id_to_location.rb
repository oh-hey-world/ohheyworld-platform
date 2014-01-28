class AddCityIdToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :city_id, :integer
    rename_column :locations, :city, :city_name
  end
end
