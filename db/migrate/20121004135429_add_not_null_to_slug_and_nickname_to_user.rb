class AddNotNullToSlugAndNicknameToUser < ActiveRecord::Migration
  def change
    change_column :users, :nickname, :string, :null => false
    change_column :users, :slug, :string, :null => false
  end
end
