class DefaultPrivateOldToUserLocation < ActiveRecord::Migration
  def up
    UserLocation.where('private IS NULL').update_all(private: false)
  end

  def down
  end
end
