class AddAdminToCommunityProfiles < ActiveRecord::Migration
  def change
    add_column :community_profiles, :admin, :boolean, default: false
  end
end
