node(:total_pages) { |m| @user_friends.total_pages }
node(:total_entries) { |m| @user_friends.total_entries }
collection @user_friends => :user_friends
attributes
child(:friend) do
    attributes :email, :first_name, :last_name, :profile_picture_url, :slug, :user_name
    child(:current_location) do
        child(:location) { attributes :latitude, :longitude, :address, :city_name, :state_name, :country_name}
    end
end