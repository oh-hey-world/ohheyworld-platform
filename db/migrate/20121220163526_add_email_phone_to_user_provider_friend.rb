class AddEmailPhoneToUserProviderFriend < ActiveRecord::Migration
  def change
    add_column :user_provider_friends, :email, :string

    add_column :user_provider_friends, :phone, :string

  end
end
