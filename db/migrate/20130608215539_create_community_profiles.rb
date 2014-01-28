class CreateCommunityProfiles < ActiveRecord::Migration
  def change
    create_table :community_profiles do |t|
      t.integer :user_id
      t.integer :community_id
      t.text :tagline
      t.text :answer

      t.timestamps
    end

    add_column :communities, :question, :text
  end
end
