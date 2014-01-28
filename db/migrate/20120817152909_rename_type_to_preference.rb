class RenameTypeToPreference < ActiveRecord::Migration
  def up
    rename_column :preferences, :type, :type_name
  end

  def down
  end
end
