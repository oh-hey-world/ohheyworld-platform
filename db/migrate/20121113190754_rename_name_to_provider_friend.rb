class RenameNameToProviderFriend < ActiveRecord::Migration
  def up
    rename_column :provider_friends, :name, :username
  end

  def down
  end
end
