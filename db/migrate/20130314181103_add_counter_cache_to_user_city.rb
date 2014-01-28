class AddCounterCacheToUserCity < ActiveRecord::Migration
  def change
    add_column :user_cities, :user_city_tips_count, :integer
  end
end
