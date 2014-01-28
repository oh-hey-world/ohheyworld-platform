class CreateRegistrationCodes < ActiveRecord::Migration
  def change
    create_table :registration_codes do |t|
      t.string :code
      t.integer :uses

      t.timestamps
    end
  end
end
