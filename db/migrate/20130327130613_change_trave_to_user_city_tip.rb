class ChangeTraveToUserCityTip < ActiveRecord::Migration
  def up
    rename_column :user_city_tips, :trave_profile, :travel_profile
  end

  def down
  end
end
