class RemoveColumnToUserLocation < ActiveRecord::Migration
  def up
    remove_column :user_locations, :user_input
    add_column :locations, :user_input, :string
  end

  def down
  end
end
