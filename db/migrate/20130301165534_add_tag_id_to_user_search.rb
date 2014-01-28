class AddTagIdToUserSearch < ActiveRecord::Migration
  def change
    add_column :user_searches, :tag_id, :integer
  end
end
