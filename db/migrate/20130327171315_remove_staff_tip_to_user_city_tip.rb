class RemoveStaffTipToUserCityTip < ActiveRecord::Migration
  def up
    remove_column :user_city_tips, :staff_tip
  end

  def down
  end
end
