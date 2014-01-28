class RemoveRatingToUserCityTip < ActiveRecord::Migration
  def up
    remove_column :user_city_tips, :rating
  end

  def down
  end
end
