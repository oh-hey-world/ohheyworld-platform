class AddLatitudeToState < ActiveRecord::Migration
  def change
    add_column :states, :code, :string

    add_column :states, :latitude, :float

    add_column :states, :longitude, :float

  end
end
