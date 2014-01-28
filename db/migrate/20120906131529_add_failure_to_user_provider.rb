class AddFailureToUserProvider < ActiveRecord::Migration
  def change
    add_column :user_providers, :failed_post, :boolean

    add_column :user_providers, :failed_token, :boolean

  end
end
