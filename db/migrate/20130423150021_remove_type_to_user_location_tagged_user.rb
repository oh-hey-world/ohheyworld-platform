class RemoveTypeToUserLocationTaggedUser < ActiveRecord::Migration
  def up
    remove_column :user_location_tagged_users, :type
  end

  def down
  end
end
