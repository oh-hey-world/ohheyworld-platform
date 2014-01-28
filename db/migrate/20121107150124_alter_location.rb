class AlterLocation < ActiveRecord::Migration
  def up
    add_column :locations, :state_id, :integer
    add_column :locations, :country_id, :integer
    rename_column :locations, :state, :state_name
    rename_column :locations, :country, :country_name
  end

  def down
  end
end
