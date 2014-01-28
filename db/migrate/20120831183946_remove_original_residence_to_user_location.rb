class RemoveOriginalResidenceToUserLocation < ActiveRecord::Migration
  def up
    remove_column :user_locations, :original_residence
    add_column :users, :home_town_location, :integer
  end

  def down
  end
end
