class AddFailure2ToUserProvider < ActiveRecord::Migration
  def change
    add_column :user_providers, :failed_app_deauthorized, :boolean
  end
end
