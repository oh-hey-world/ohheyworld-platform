node(:scope) { |m| params[:scope] }
node(:type) { |m| "UserFriends" }
collection @states => :grouped_parents
attributes :name, :code, :latitude, :longitude, :state_country, :country_name
child(:user_friends => :children) do
  attributes :count_all, :city_name, :state_name
end