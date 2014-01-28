class AddNotes < ActiveRecord::Migration
  def self.up
    create_table :user_location_notes do |t|
      t.string :title, :limit => 50, :default => ""
      t.text :note, :default => ""
      t.references :user
      t.references :user_location
      t.timestamps
    end

    add_index :user_location_notes, :user_id
    add_index :user_location_notes, :user_location_id
  end

  def self.down
    drop_table :user_location_notes
  end
end
