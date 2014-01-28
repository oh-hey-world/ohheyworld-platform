class CreateUserContacts < ActiveRecord::Migration
  def change
    create_table :user_contacts do |t|
      t.integer :user_id
      t.integer :contact_id
      t.string :subject
      t.text :message
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
