class AddColumnToPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :type, :string

  end
end
