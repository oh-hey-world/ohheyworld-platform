node(:total_pages) { |m| @locations.total_pages }
node(:total_entries) { |m| @locations.total_entries}
collection @locations => :locations
attributes :latitude, :longitude, :address, :city_name, :state_name, :country_name