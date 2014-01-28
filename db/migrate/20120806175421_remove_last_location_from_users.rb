class RemoveLastLocationFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :last_location
  end

  def down
  end
end
