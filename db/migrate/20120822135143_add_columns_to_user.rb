class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :hometown, :string

    add_column :users, :picture_url, :string

  end
end
