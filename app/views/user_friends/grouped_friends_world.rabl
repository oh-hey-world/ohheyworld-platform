node(:scope) { |m| params[:scope] }
node(:type) { |m| "UserFriends" }
collection @countries => :grouped_parents
attributes :name, :code, :latitude, :longitude
child(:user_friends => :children) do
  attributes :count_all, :city_name, :state_name
end