class AddPrivateToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :private, :boolean
  end
end
