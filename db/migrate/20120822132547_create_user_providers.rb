class CreateUserProviders < ActiveRecord::Migration
  def change
    create_table :user_providers do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.integer :timezone
      t.string :locale
      t.string :link
      t.string :hometown
      t.string :picture_url
      t.string :provider_token
      t.integer :provider_token_timeout

      t.timestamps
    end
  end
end
