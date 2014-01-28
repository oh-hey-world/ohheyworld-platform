class CreateUserCityTips < ActiveRecord::Migration
  def change
    create_table :user_city_tips do |t|
      t.integer :user_id
      t.integer :city_id
      t.text :tip
      t.decimal :rating

      t.timestamps
    end
  end
end
