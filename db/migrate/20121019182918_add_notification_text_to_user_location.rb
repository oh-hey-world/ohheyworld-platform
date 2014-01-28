class AddNotificationTextToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :custom_message, :text

  end
end
