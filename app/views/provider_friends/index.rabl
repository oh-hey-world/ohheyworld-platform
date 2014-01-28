node(:total_pages) { |m| @provider_friends.total_pages }
node(:total_entries) { |m| @provider_friends.total_entries}
collection @provider_friends => :provider_friends
attributes :user_name, :picture_url, :link, :username
child(:location) do
    attributes :latitude, :longitude, :address, :city_name, :state_name, :country_name
end