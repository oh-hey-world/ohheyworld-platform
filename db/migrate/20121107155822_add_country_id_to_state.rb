class AddCountryIdToState < ActiveRecord::Migration
  def change
    add_column :states, :country_id, :integer

  end
end
