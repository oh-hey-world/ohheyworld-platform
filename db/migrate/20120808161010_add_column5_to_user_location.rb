class AddColumn5ToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :current, :boolean, :default => true

  end
end
