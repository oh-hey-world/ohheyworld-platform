class AddColumnsToUserProvider < ActiveRecord::Migration
  def change
    add_column :user_providers, :secret, :string

    add_column :user_providers, :full_name, :string

    add_column :user_providers, :nickname, :string

    add_column :user_providers, :description, :string

    add_column :user_providers, :website, :string

    add_column :user_providers, :geo_enabled, :boolean

  end
end
