class AddFailure3ToUserProvider < ActiveRecord::Migration
  def change
    rename_column :user_providers, :failed_post, :failed_post_deauthorized
  end
end
