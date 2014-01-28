class RemoveProviderColumnsToUser < ActiveRecord::Migration
  def up
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :link
    remove_column :users, :hometown
    remove_column :users, :picture_url
    remove_column :users, :provider_token
    remove_column :users, :provider_token_timeout
  end

  def down
  end
end
