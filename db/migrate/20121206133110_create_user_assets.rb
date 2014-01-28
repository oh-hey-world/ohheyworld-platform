class CreateUserAssets < ActiveRecord::Migration
  def change
    create_table :user_assets do |t|
      t.integer :user_id
      t.has_attached_file :asset
      t.string :type
      t.boolean :default
      t.timestamps
    end
  end
end
