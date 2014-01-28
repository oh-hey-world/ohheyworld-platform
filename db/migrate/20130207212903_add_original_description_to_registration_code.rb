class AddOriginalDescriptionToRegistrationCode < ActiveRecord::Migration
  def change
    add_column :registration_codes, :original_amount, :integer
    add_column :registration_codes, :description, :text
  end
end
