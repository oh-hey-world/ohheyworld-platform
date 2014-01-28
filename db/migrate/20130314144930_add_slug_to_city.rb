class AddSlugToCity < ActiveRecord::Migration
  def change
    add_column :cities, :slug, :string
    add_index :cities, :slug, unique: true
    City.find_each do |city|
      city.save
    end
  end
end
