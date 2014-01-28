class AddSlugToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :slug, :string
  end
end
