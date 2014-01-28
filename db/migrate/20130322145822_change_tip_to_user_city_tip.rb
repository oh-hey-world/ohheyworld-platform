class ChangeTipToUserCityTip < ActiveRecord::Migration
  def up
    change_column :user_city_tips, :tip, :string
  end

  def down
  end
end
