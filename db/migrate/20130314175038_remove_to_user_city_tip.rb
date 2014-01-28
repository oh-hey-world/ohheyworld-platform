class RemoveToUserCityTip < ActiveRecord::Migration
  def up
    remove_column :user_city_tips, :city_id
    remove_column :user_city_tips, :user_id
  end

  def down
  end
end
