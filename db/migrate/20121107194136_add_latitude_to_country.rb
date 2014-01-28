class AddLatitudeToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :code, :string

    add_column :countries, :latitude, :float

    add_column :countries, :longitude, :float

  end
end
