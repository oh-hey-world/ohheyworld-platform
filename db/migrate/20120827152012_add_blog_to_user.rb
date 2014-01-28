class AddBlogToUser < ActiveRecord::Migration
  def change
    add_column :users, :blog_url, :string

  end
end
