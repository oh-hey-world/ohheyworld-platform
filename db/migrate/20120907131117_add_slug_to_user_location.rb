class AddSlugToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :slug, :string

  end
end
