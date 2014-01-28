class AddSendOverridesToUser < ActiveRecord::Migration
  def change
    add_column :users, :send_overrides, :text

  end
end
