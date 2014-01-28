class UserFriendsController < ApplicationController
  
  def index
    @user_friends = UserFriend.users_with_current_location(current_user, true, params[:page])
    respond_to do |format|
      format.json
    end
  end

  def following
    @user = User.find(params[:user_id])
    @user_friends = UserFriend.all_user_friends(@user, params[:page])
  end

  def followers
    @user = User.find(params[:user_id])
    @user_friends = UserFriend.all_user_followers(@user, params[:page])
  end

  def grouped_friends
    @user = current_user
    if params[:scope] == "US"
      @country = Country.find_by_code("US")
      @user_friends = UserFriend.grouped_user_friends_not_ohw_user_in_country(@user, @country.code)
      @states = State.by_ids(@user_friends.map(&:state_id).uniq)
      @states.each do |state|
        state.user_friends = @user_friends.select{|x| x.state_name == state.name}
      end
    else
      @user_friends = UserFriend.grouped_user_friends_not_ohw_user_in_world(@user)
      @countries = Country.by_ids(@user_friends.map(&:country_id).uniq)
      @countries.each do |country|
        country.user_friends = @user_friends.select{|x| x.country_name == country.name}
      end
      render "grouped_friends_world"
    end
  end

  def show
  end

  def create
    user_friend = UserFriend.find_by_user_id_and_friend_id(params[:user_friend][:user_id], params[:user_friend][:friend_id])
    if (user_friend)
      if params[:type] == "update"
        user_friend.update_attributes(params[:user_friend])
      else
        user_friend.destroy
      end
      success = true
    else
      user_friend = UserFriend.new(params[:user_friend])
      success = user_friend.save
    end
    user_provider_friend = UserProviderFriend.ohw_user(user_friend)
    user_provider_friend.update_attributes(following: (user_friend.new_record? || user_friend.persisted?)) if user_provider_friend
    respond_to do |format|
      if success
        @user = user_friend.friend
        format.js
      else
        format.js { render json: user_friend, status: :unprocessable_entity }
      end
    end
  end
  
  def dashboard
    if current_user
      @comments_closed = true
      case params[:view]
        when "close_friends"
          @people = UserLocation.locations_user_friends_by_tag(current_user, 'Close Friends', params[:page])
        when "family"
          @people = UserLocation.locations_user_friends_by_tag(current_user, 'Family', params[:page])
        when "ohw_network"
          @people = UserLocation.ohw_network(current_user, params[:page])
        else
          @people = UserLocation.locations_user_friends(current_user, params[:page])
      end
    end
  end

  def update
    @user_friend = UserFriend.find(params[:id])
    respond_to do |format|    
      if @user_friend.update_attributes(params[:user_friend])
        format.js
      else
        format.js { render json: @user_friend, status: :unprocessable_entity }
      end
    end
  end

  def network
    @user = current_user
    input = [params[:city], params[:state], params[:country]].compact.reject { |x| x == "null"}.join(", ")
    @current_location = Location.find_or_create_by_user_input(input)
    if @current_location && @user
      @user_friends_at_location = UserFriend.user_friends_not_ohw_user_in_city_state_country(@user, @current_location, params[:page])
      @user_friends = User.user_with_ids(@user_friends_at_location.map(&:friend_id), params[:page])
    end
  end

  def update_tag
    #"user_friend"=>{"user_id"=>"2", "friend_id"=>"3"}, "tag"=>"Family"}
    @user_friend = UserFriend.find_by_user_id_and_friend_id(params[:user_friend][:user_id], params[:user_friend][:friend_id])
    tag = params[:tag]
    if @user_friend && (tag == "Unfollow" || tag == "Following")
      @user_friend.destroy
    else
      #if we dont have a user_friend we will need one b/c we must be adding
      @user_friend = UserFriend.create(params[:user_friend]) unless @user_friend
      unless (tag == "Follow" || tag == "Following")
        if @user_friend.tag_list.include?(tag)
          @user_friend.tag_list.remove(tag)
        else
          @user_friend.tag_list << tag
        end
      end
      respond_to do |format|
        if @user_friend.save
          format.js { render json: @user_friend, content_type: 'text/json' }
        else
          format.js { render json: @user_friend, status: :unprocessable_entity }
        end
      end
    end
  end

  def send_invitation_email
    NotificationMailer.delay.invite_to_ohw(current_user, params[:user][:email])
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def destroy
  end
end
