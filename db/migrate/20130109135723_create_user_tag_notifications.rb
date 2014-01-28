class CreateUserTagNotifications < ActiveRecord::Migration
  def change
    create_table :user_tag_notifications do |t|
      t.integer :user_id
      t.string :tag
      t.boolean :sms
      t.boolean :email

      t.timestamps
    end
  end
end
