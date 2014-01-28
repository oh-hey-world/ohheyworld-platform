class AddTravelProfileToUserCityTip < ActiveRecord::Migration
  def change
    add_column :user_city_tips, :trave_profile, :string
  end
end
