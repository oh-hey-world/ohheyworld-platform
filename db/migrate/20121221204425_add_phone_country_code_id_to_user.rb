class AddPhoneCountryCodeIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_country_code_id, :integer
    remove_column :users, :phone_country_code
  end
end
