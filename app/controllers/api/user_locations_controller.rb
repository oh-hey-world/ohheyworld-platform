class Api::UserLocationsController < Api::BaseController
  before_filter :setup_user_location, only: [:user_friends_not_ohw_user, :users_at_location, :user_friends_ohw_user]
  
  def index
    @user_locations = current_user.user_locations
    render "index"
  end
  
  def user_friends_not_ohw_user
    @provider_friends = ProviderFriend.user_friends_not_ohw_user(@user, @user_location.location, true, params[:page])
    render "api/users/provider_friends"
  end
  
  def users_at_location
    @users_at_location = User.users_at_location(@user_location.location, @user, true, params[:page])
    render "api/users/index"
  end
  
  def user_friends_ohw_user
    @provider_friends = ProviderFriend.user_friends_ohw_user(@user, @user_location.location, true, params[:page])
    render "api/users/provider_friends"
  end
  
  def create
    location_params = params["user_locations.user_location"].delete(:location)
    user_location = UserLocation.new(params["user_locations.user_location"])
    user_location.location = Location.find_or_create_by_user_input(location_params[:user_input])
    user_location.source = 'api'
    user_location.save

    second_most_recent_place = current_user.second_most_recent_place
    second_most_recent_place.update_attribute(:ended_at, user_location.created_at) if second_most_recent_place && second_most_recent_place.ended_at.blank?

    unless user_location.persisted?
      user_location = current_user.current_location
      current_user.post_notifications(user_location) if user_location && current_user.completed_first_checkin
    end
    if (user_location)
      @user_locations = current_user.user_locations
      render "index"
    else
      errors = user_location.errors if user_location
      render json: {success:false, message: errors, status: :unprocessable_entity}
    end
  end
  
  def setup_user_location
    @user_location = UserLocation.find(params[:id])
    @user = @user_location.user
  end
  
end