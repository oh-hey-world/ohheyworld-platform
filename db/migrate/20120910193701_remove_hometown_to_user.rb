class RemoveHometownToUser < ActiveRecord::Migration
  def up
    remove_column :users, :hometown
  end

  def down
  end
end
