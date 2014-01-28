class DefaultPrivateToFalseToUserLocation < ActiveRecord::Migration
  def up
    change_column :user_locations, :private, :boolean, :default => false
  end

  def down
  end
end
