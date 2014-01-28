class AddCompletedFirstCheckinToUser < ActiveRecord::Migration
  def change
    add_column :users, :completed_first_checkin, :boolean

  end
end
