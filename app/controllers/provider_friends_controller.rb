class ProviderFriendsController < ApplicationController
  def index
    @provider_friends = ProviderFriend.user_friends_with_location(current_user, params[:page])
    respond_to do |format|
      format.json
    end
  end

  def network
    @user = current_user
    input = [params[:city], params[:state], params[:country]].compact.reject { |x| x == "null"}.join(", ")
    @current_location = Location.find_or_create_by_user_input(input)
    if @user and @current_location
      @provider_friends = ProviderFriend.user_friends_not_ohw_user_in_city_state_country(@user, @current_location, params[:page])
    end
  end

  def grouped_friends
    @user = current_user
    if params[:scope] == "US"
      @country = Country.find_by_code("US")
      @provider_friends = ProviderFriend.grouped_user_friends_not_ohw_user_in_country(@user, @country.code)
      @states = State.by_ids(@provider_friends.map(&:state_id).uniq)
      @states.each do |state|
        state.provider_friends = @provider_friends.select{|x| x.state_name == state.name}
      end
    else
      @provider_friends = ProviderFriend.grouped_user_friends_not_ohw_user_in_world(@user)
      @countries = Country.by_ids(@provider_friends.map(&:country_id).uniq)
      @countries.each do |country|
        country.provider_friends = @provider_friends.select{|x| x.country_name == country.name}
      end
      render "grouped_friends_world"
    end
  end
end

