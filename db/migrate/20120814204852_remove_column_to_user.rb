class RemoveColumnToUser < ActiveRecord::Migration
  def up
    remove_column :users, :location_city
        remove_column :users, :location_state
      end

  def down
    add_column :users, :location_state, :string
    add_column :users, :location_city, :string
  end
end
