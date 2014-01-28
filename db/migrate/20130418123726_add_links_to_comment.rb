class AddLinksToComment < ActiveRecord::Migration
  def change
    add_column :comments, :links, :text
  end
end
