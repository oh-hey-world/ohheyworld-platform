class StaffTip2ToUserCityTip < ActiveRecord::Migration
  def up
    add_column :user_city_tips, :staff_tip, :boolean
  end

  def down
  end
end
