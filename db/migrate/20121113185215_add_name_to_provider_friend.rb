class AddNameToProviderFriend < ActiveRecord::Migration
  def change
    add_column :provider_friends, :name, :string

  end
end
