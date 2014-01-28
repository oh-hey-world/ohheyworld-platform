class AddEndDateToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :ended_at, :datetime

  end
end
