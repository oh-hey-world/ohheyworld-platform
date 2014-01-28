class AddMoreColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string

    add_column :users, :last_name, :string

    add_column :users, :last_location, :string

    add_column :users, :gender, :string

    add_column :users, :timezone, :integer

    add_column :users, :locale, :string

    add_column :users, :link, :string

    add_column :users, :hometown, :string

  end
end
