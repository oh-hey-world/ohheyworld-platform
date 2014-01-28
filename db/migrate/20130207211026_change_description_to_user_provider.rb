class ChangeDescriptionToUserProvider < ActiveRecord::Migration
  def up
    change_column :user_providers, :description, :text
  end

  def down
  end
end
