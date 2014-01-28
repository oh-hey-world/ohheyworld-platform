class AddResidenceToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :residence, :boolean

  end
end
