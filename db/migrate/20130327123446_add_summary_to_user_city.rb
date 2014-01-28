class AddSummaryToUserCity < ActiveRecord::Migration
  def change
    add_column :user_cities, :summary, :text
  end
end
