class AddSlugIndexToUserLocation < ActiveRecord::Migration
  def change
    add_index :user_locations, [:user_id, :slug], :unique => true
  end
end
