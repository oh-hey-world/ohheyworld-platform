class LocationsController < ApplicationController
  skip_authorize_resource only: [:index]
  skip_before_filter :require_login, only: [:index]
  
  def index
    render json: Location.search_address(params[:q])
  end

  def provider_friends
    @locations = Location.location_user_provider_friends(current_user, params[:page])
    respond_to do |format|
      format.json
    end
  end
end
