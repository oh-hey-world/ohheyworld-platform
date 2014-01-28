class AddPhoneCountryCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_country_code, :string

  end
end
