class AddauthenticationTokenToUsers < ActiveRecord::Migration
  def up
    add_column :users, :authentication_token, :string
    
    add_index :users, :authentication_token, :unique => true
  end

  def down
  end
end
