class AddCustomFieldToCommunityProfiles < ActiveRecord::Migration
  def change
    add_column :community_profiles, :custom_field, :string
    add_column :communities, :custom_field_label, :string
  end
end
