class AddUserCityIdToUserCityTip < ActiveRecord::Migration
  def change
    add_column :user_city_tips, :user_city_id, :integer
  end
end
