class ChangeBlurbUser < ActiveRecord::Migration
  def up
    change_column :users, :blurb, :text

  end

  def down
  end
end
