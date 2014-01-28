class CreateNotificationContactDetails < ActiveRecord::Migration
  def change
    create_table :notification_contact_details do |t|
      t.string :name
      t.string :value
      t.string :type
      t.integer :user_id

      t.timestamps
    end
  end
end
