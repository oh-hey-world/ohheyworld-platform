class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string :name
      t.string :value
      t.integer :user_id

      t.timestamps
    end
  end
end
