class AddLinkToUserCityTip < ActiveRecord::Migration
  def change
    add_column :user_city_tips, :link_name, :string
    add_column :user_city_tips, :link_value, :string
  end
end
