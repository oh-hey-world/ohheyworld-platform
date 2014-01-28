class AddColumns5ToUser < ActiveRecord::Migration
  def change
    add_column :users, :blurb, :string

    add_column :users, :birthday, :datetime

  end
end
