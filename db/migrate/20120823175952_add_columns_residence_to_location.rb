class AddColumnsResidenceToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :residence, :boolean

  end
end
