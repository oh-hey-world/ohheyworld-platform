class ChangeSlugNameOnCommunities < ActiveRecord::Migration
  def change
    rename_column :communities, :slug, :community_slug
  end
end
