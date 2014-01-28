class AddSentSnapshotToUserLocation < ActiveRecord::Migration
  def change
    add_column :user_locations, :sent_snapshot, :text

  end
end
