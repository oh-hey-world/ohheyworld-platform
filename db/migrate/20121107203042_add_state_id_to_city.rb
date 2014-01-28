class AddStateIdToCity < ActiveRecord::Migration
  def change
    add_column :cities, :state_id, :integer

  end
end
