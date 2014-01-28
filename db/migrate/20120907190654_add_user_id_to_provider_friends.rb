class AddUserIdToProviderFriends < ActiveRecord::Migration
  def change
    add_column :provider_friends, :user_id, :integer

  end
end
