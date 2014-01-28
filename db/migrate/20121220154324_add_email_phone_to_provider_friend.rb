class AddEmailPhoneToProviderFriend < ActiveRecord::Migration
  def change
    add_column :provider_friends, :email, :string

    add_column :provider_friends, :phone, :string

  end
end
