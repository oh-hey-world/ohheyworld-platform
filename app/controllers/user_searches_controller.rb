class UserSearchesController < ApplicationController
  before_filter :find_search, only: [:show, :more_users_with_tag]
  
  def create
    @new_user_search = UserSearch.new(params[:user_search])
    if params[:search_type] == "location"
      @new_user_search.location_id = params[:search_id]
    else
      @new_user_search.tag_id = params[:search_id]
    end
    if (@new_user_search.save)
      if @new_user_search.location
        redirect_to user_search_path(@new_user_search)
      else
        redirect_to users_tags_path((@new_user_search.tag) ? @new_user_search.tag.name : params[:user_search][:user_input])
      end
    else
      render action: "new"
    end
  end

  def site_search
    @locations = Location.search_address(params[:q])
    #@users_with_tags = User.by_wild_tag(current_user, params[:q])
    #@tags = Tag.tag_search(params[:q])
    respond_to do |format|
      format.json
    end
  end

  def show
    if @last_user_search && @user
      @current_location = @last_user_search.location
        if @current_location
          @total_tips_for_city = UserCityTip.total_tips_for_city(@current_location.city_id)
          if current_user && current_user.is_allowed_content_creation?
            user_city_user_id = (params[:impersonate]) ? User.find(params[:impersonate]).id : current_user.id
            user_city_user_id = nil if params[:staff_city]
            @user_city = UserCity.find_or_initialize_by_user_id_and_city_id(user_city_user_id, @current_location.city_id)
            @user_city_tip = @user_city.user_city_tips.build
          end
          @provider_friends = ProviderFriend.user_friends_not_ohw_user(@user, @last_user_search.location, false, params[:friends_page])
          @users_at_location = User.users_at_location(@last_user_search.location, @user, false, params[:location_page])
          @users_at_location_friends = UserFriend.user_friends_nearby_location(@user, @last_user_search.location, params[:friends_location_page])
          @facebook_friends_of_friends_page = ProviderFriend.user_provider_friends_of_friends_not_ohw_user(@user, @last_user_search.location, 'facebook', false, params[:facebook_friends_of_friends_page])

          @user_friends_at_location = UserFriend.friends_in_clause(@user, @users_at_location.map{ |user| user.id })
        end
    end
  end
  
  def new
  end

  def more_users_with_tag
    @users_with_tags = User.by_tag(current_user, @last_user_search.user_input, params[:user_tags_page])
  end

  def more_friends
    @page_param = params[:page_param]
    @user_search = UserSearch.find(params[:id])
    @location = @user_search.location
    if current_user && @location
      case @page_param
        when "friends_location_page"
          #friends_location_page
          @people = UserFriend.user_friends_nearby_location(current_user, @location, params[:page]) #ProviderFriend.user_friends_ohw_user(@user, @user_location.location, false, params[:page])
        when "friends_page"
          @people = ProviderFriend.user_friends_not_ohw_user(current_user, @location, false, params[:page])
        when "location_page"
          @people = User.users_at_location(@location, current_user, false, params[:page])
        when "facebook_friends_of_friends_page"
          @people = ProviderFriend.user_provider_friends_of_friends_not_ohw_user(current_user, @location, 'facebook', false, params[:page])
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def find_search
    @last_user_search = UserSearch.find(params[:id])
    @user = current_user
  end

  def search_users
    limit = 25
    user_location = UserLocation.find(params[:user_location_id])
    user_ids = user_location.user_location_tagged_users.map(&:user_id)
    provider_friend_ids = user_location.user_location_tagged_users.map(&:provider_friend_id).compact
    search_params = {user_name: "#{params[:q]}%", user_ids: (user_ids.size > 0) ? user_ids : 0, provider_friend_ids: (provider_friend_ids.size > 0) ? provider_friend_ids : 0, user_id: current_user.id}
    users_where = '(users.nickname ILIKE :user_name OR users.first_name ILIKE :user_name OR users.last_name ILIKE :user_name OR user_providers.nickname ILIKE :user_name OR user_providers.full_name ILIKE :user_name) AND users.id NOT IN (:user_ids) AND users.id != :user_id'
    providers_where = '(user_name ILIKE :user_name OR username ILIKE :user_name) AND user_id IS NULL'
    providers_where << ' AND provider_friends.id NOT IN (:provider_friend_ids)' if provider_friend_ids.size > 0
    @search_users = User.select('DISTINCT users.*').includes(:user_providers).where(users_where, search_params).limit(limit)
    @search_provider_friends = ProviderFriend.select('DISTINCT provider_friends.*').where(providers_where, search_params).limit(limit)
  end
end
