class AddImportJobToUser < ActiveRecord::Migration
  def change
    add_column :users, :import_job_id, :integer

    add_column :users, :import_job_finished_at, :datetime

  end
end
