class SlugToUserLocation < ActiveRecord::Migration
  def up
    UserLocation.find_each(&:save)
  end

  def down
  end
end
