collection @user_locations => :user_locations
attributes :id, :user_id, :created_at, :updated_at, :location_id, :current, :ended_at, :residence, :slug, :name, :sent_snapshot
child(:location) { attributes :id, :latitude, :longitude, :address, :city_name, :state_name, :state_code, :postal_code, :country_name, :country_code, :created_at, :updated_at, :user_input, :residence}