class AddSourceToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :source, :string

  end
end
