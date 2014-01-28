class CreateBetaAccessRequests < ActiveRecord::Migration
  def change
    create_table :beta_access_requests do |t|
      t.string :email

      t.timestamps
    end
  end
end
