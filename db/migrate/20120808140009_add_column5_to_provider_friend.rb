class AddColumn5ToProviderFriend < ActiveRecord::Migration
  def change
    add_column :provider_friends, :link, :string
  end
end
