class AddColumnTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider_token_timeout, :integer

  end
end
