node(:scope) { |m| params[:scope] }
node(:type) { |m| "ProviderFriends" }
collection @countries => :grouped_parents
attributes :name, :code, :latitude, :longitude
child(:provider_friends => :children) do
  attributes :count_all, :city_name, :state_name
end