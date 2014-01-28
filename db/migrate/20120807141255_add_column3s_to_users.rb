class AddColumn3sToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_picture, :string

    add_column :users, :location_city, :string

    add_column :users, :location_state, :string

  end
end
