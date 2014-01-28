class SetDefaultCurrentToUserLocation < ActiveRecord::Migration
  def up
    change_column_default(:user_locations, :current, false)
  end

  def down
  end
end
