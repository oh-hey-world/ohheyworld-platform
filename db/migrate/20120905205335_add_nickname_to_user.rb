class AddNicknameToUser < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :string

    add_column :users, :slug, :string
    add_index :users, :slug, unique: true
  end
end
