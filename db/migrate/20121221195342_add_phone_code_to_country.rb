class AddPhoneCodeToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :phone_code, :string

  end
end
