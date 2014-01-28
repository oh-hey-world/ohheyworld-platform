class AddLinkValuesToComment < ActiveRecord::Migration
  def change
    add_column :comments, :link_name, :string
    add_column :comments, :link_value, :string
    remove_column :comments, :links
  end
end
