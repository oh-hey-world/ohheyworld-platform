collection @user_provider_friends => :user_provider_friends
attributes :id, :user_id, :created_at, :updated_at, :provider_friend_id, :following
child(:provider_friend) do
  attributes :id, :provider_name, :user_name, :uid, :picture_url, :created_at, :updated_at, :link, :location_id, :user_id, :username
  child(:location) { attributes :id, :latitude, :longitude, :address, :city_name, :state_name, :state_code, :postal_code, :country_name, :country_code, :created_at, :updated_at, :user_input, :residence}
end
