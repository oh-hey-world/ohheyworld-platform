class AddFollowingToUserProviderFriend < ActiveRecord::Migration
  def change
    add_column :user_provider_friends, :following, :boolean

  end
end
