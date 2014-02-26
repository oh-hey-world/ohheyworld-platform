class AddQuestionToggleToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :display_love_question, :boolean
  end
end
