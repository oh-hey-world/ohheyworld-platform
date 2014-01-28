class RenameColumn6ToUser < ActiveRecord::Migration
  def up
    rename_column :users, :profile_picture, :picture_url
  end

  def down
  end
end
