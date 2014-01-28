class AddSearchTextToUserSearch < ActiveRecord::Migration
  def change
    add_column :user_searches, :user_input, :string
  end
end
