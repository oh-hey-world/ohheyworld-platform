class RenameHomeTownLocationToUser < ActiveRecord::Migration
  def up
    rename_column :users, :home_town_location, :home_town_location_id
  end

  def down
  end
end
