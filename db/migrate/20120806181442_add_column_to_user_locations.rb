class AddColumnToUserLocations < ActiveRecord::Migration
  def change
    add_column :user_locations, :user_input, :string

  end
end
