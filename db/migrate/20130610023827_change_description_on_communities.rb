class ChangeDescriptionOnCommunities < ActiveRecord::Migration
  def change
    change_column :communities, :description, :text
    add_column :communities, :tagline, :string
  end
end
