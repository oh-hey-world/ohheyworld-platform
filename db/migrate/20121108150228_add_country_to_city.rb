class AddCountryToCity < ActiveRecord::Migration
  def change
    add_column :cities, :country_id, :integer

  end
end
