class AddOriginalResidenceToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :original_residence, :boolean

  end
end
