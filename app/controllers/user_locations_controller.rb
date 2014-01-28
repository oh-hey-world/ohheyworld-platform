class UserLocationsController < ApplicationController
  skip_authorize_resource :only => [:index, :show]
  before_filter :validate_user, :only => [:update, :destroy, :update_user, :update_photos, :update_user_preference]
  before_filter :setup_show, :only => [:show, :add_comment, :add_note, :friends]
  respond_to :html, :json, :js
  inherit_resources
  actions :all, :except => [ :edit, :update, :destroy, :new, :create ]
  belongs_to :user
  skip_before_filter :require_login, only: [:show]
  
  def index

  end

  def new

  end
  
  def show
  end

  def friends

  end

  def more_friends
    @page_param = params[:page_param]
    @user_location = UserLocation.find(params[:id])
    @user = @user_location.user
    if @user && @user_location
      if is_same_user?
        case @page_param
          when "friends_location_page"
             #friends_location_page
            @people = UserFriend.user_friends_nearby_location(@user, @user_location.location, params[:page]) #ProviderFriend.user_friends_ohw_user(@user, @user_location.location, false, params[:page])
          when "friends_page"
            @people = ProviderFriend.user_friends_not_ohw_user(@user, @user_location.location, false, params[:page])
          when "location_page"
            @people = User.users_at_location(@user_location.location, @user, false, params[:page])
          when "facebook_friends_of_friends_page"
            @people = ProviderFriend.user_provider_friends_of_friends_not_ohw_user(@user, @user_location.location, 'facebook', false, params[:page])
        end
      end
      respond_to do |format|
        format.js
      end
    end
  end
  
  def setup_show
    @user_location = UserLocation.joins(:user, :location).find(params[:id])
    @user = @user_location.user
    if @user && @user_location
      @total_tips_for_city = UserCityTip.total_tips_for_city(@user_location.location.city_id)
      if current_user && current_user.is_allowed_content_creation?
        user_city_user_id = (params[:impersonate]) ? User.find(params[:impersonate]).id : current_user.id
        user_city_user_id = nil if params[:staff_city]
        @user_city = UserCity.find_or_initialize_by_user_id_and_city_id(user_city_user_id, @user_location.location.city_id)
        @user_city_tip = @user_city.user_city_tips.build
      end
      @current_location = @user_location.location
      @prior_user_location = @user.prior_location(@user_location)
      if is_same_user? && !@user.agrees_to_terms
        mom = current_user.notification_contact_details.build
        mom.placeholder_name = "Mom"
        mom.placeholder_value = "555-555-5555"
        dad = current_user.notification_contact_details.build
        dad.placeholder_name = "Dad"
        dad.placeholder_value = "email@email.com"
        susie = current_user.notification_contact_details.build
        susie.placeholder_name = "Susie"
        susie.placeholder_value = "555-555-5555"
        @mom_and_dad_notification_details = [mom, dad]
        @friend_notification_details = susie
      end
      if is_same_user?
        @user_location_tagged_user = @user_location.user_location_tagged_users.build
        @last_time_visited = @user.last_time_visited_place(@user_location.location_id).first
        @countries_visited = @user.countries_visited
        #1.times { @user_location.user_location_assets.build }
      else
        @next_user_location = @user.next_location(@user_location)
        @recent_locations = @user.most_recent_places
      end
      @users_at_location_friends = UserFriend.user_friends_nearby_location(current_user, @user_location.location, params[:friends_location_page])
        #ProviderFriend.user_friends_ohw_user(current_user, @user_location.location, false, params[:friends_location_page]) #friends_location_page
      @provider_friends = ProviderFriend.user_friends_not_ohw_user(current_user, @user_location.location, false, params[:friends_page])  #friends_page
      @users_at_location = User.users_at_location(@user_location.location, current_user, false, params[:location_page]) #location_page
      @facebook_friends_of_friends_page = ProviderFriend.user_provider_friends_of_friends_not_ohw_user(current_user, @user_location.location, 'facebook', false, params[:facebook_friends_of_friends_page]) #facebook_friends_of_friends_page
      @users_with_tag_at_location = User.by_tags_at_location(current_user,  @user_location.location, params[:similar_location_page])
    end
  end

  def add_comment
    @comment = Comment.create(params[:comment])
    if @comment.save
      respond_to do |format|
        flash[:notice] = "Your comment was saved"
        format.html {redirect_to user_user_location_path(@user.slug, @user_location.slug)}
      end
    else
      respond_to do |format|
        format.html { render action: "show" }
      end
    end
  end

  def add_note
    @note = UserLocationNote.create(params[:user_location_note])
    if @note.save
      respond_to do |format|
        flash[:notice] = "Your note was saved"
        format.html {redirect_to user_user_location_path(@user.slug, @user_location.slug)}
      end
    else
      respond_to do |format|
        format.html { render action: "show" }
      end
    end
  end

  def create
    if (user_signed_in?)
      params[:user_location][:created_at] = UserLocation.append_current_time_to_date(params[:user_location][:created_at])
      params[:user_location][:ended_at] = UserLocation.append_current_time_to_date(params[:user_location][:ended_at])
      @new_user_location = UserLocation.new(params[:user_location])
      if (@new_user_location.save || @new_user_location.prior_location_id)
        if @new_user_location.prior_location_id
          @new_user_location = UserLocation.find(@new_user_location.prior_location_id) 
          @new_user_location.update_attribute(:current, true) #this fixes the issue of users who check into their home town the first time
          if params[:user_location][:user_location_assets_attributes] || params[:user_location][:tag_list]
            params[:user_location].delete(:location_attributes)
            params[:user_location].delete(:created_at)
            params[:user_location].delete(:ended_at)
            @new_user_location.update_attributes(params[:user_location])
          end
        end
        @second_most_recent_place = current_user.second_most_recent_place
        @second_most_recent_place.update_attribute(:ended_at, @new_user_location.created_at) if @second_most_recent_place && @second_most_recent_place.ended_at.blank?

        respond_to do |format|
          @user_locations = current_user.ordered_locations(params[:page]) 
          @user = current_user
          flash[:notice] = "You've checked in to #{@new_user_location.name}!"
          #format.html {redirect_to user_user_location_path(current_user.slug, @new_user_location.slug)}
          format.html {redirect_to user_user_location_notifications_path(current_user.slug, @new_user_location.slug)}
          format.js
        end
      else
        respond_to do |format|
          format.html { render action: "new" }
          format.js { render json: @new_user_location, status: :unprocessable_entity }
        end
      end
    end
  end

  def like_checkin
    @user_location = UserLocation.find(params[:id])
    #TODO clean this up and move to model
    respond_to do |format|
      liked = false
      if current_user.voted_up_on? @user_location
        @user_location.disliked_by current_user
      else
        @user_location.liked_by current_user
        liked = true
      end
      if liked == false || (liked && Vote.check_send_notifications(@user_location, current_user))
        format.js { render json: {'number_of_likes' => @user_location.likes.size}.to_json, content_type: 'text/json' }
      else
        format.js { render json: @user_location, status: :unprocessable_entity }
      end
    end
  end

  def like_comment
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.liked_by current_user
        format.js { render json: {'number_of_likes' => @comment.likes.size}.to_json, content_type: 'text/json' }
      else
        format.js { render json: @comment, status: :unprocessable_entity }
      end
    end
  end

  def notifications
    @new_user_location = UserLocation.find(params[:user_location_id])
    @user = current_user
  end

  def send_notifications
    if (user_signed_in?)
      facebook_enabled = (params[:user][:preferences][:facebook] == "1")
      twitter_enabled = (params[:user][:preferences][:twitter] == "1")
      send_overrides = {facebook_override: facebook_enabled, twitter_override: twitter_enabled, sms_override: true, email_override: true}
      params[:user].delete(:preferences)
      @user = User.find(current_user.id)
      if (@user.update_attributes(params[:user].merge({send_overrides:send_overrides})))
        @new_user_location = UserLocation.find(params[:user_location_id])
        @user.notification_contact_details.reload
        @user.post_notifications(@new_user_location) if @new_user_location && current_user.completed_first_checkin

        if @new_user_location.prior_location_id
          @new_user_location = UserLocation.find(@new_user_location.prior_location_id)
          @new_user_location.update_attribute(:current, true) #this fixes the issue of users who check into their home town the first time
        end
        @second_most_recent_place = current_user.second_most_recent_place
        @second_most_recent_place.update_attribute(:ended_at, @new_user_location.created_at) if @second_most_recent_place && @second_most_recent_place.ended_at.blank?

        respond_to do |format|
          @user_locations = current_user.ordered_locations(params[:page])
          flash[:notice] = "You've checked in to #{@new_user_location.name}!"
          format.html {redirect_to user_user_location_path(current_user.slug, @new_user_location.slug)}
          format.js
        end
      else
        respond_to do |format|
          format.html { render action: "notifications", user_id: @user.id }
          format.js { render json: @new_user_location, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def search_user_location
    
  end

  def update_photos
    if (@user_location.update_attributes(params[:user_location]))
      respond_to do |format|
        format.html {redirect_to user_user_location_path(current_user.slug, @user_location.slug)}
      end
    end
  end
  
  def update
    if (params[:user_location])
      params[:user_location][:user_id] = current_user.id
      ended_at = params[:user_location][:ended_at]
      if params[:user_location][:created_at]
        created_at = params[:user_location][:created_at]
        params[:user_location][:created_at] = UserLocation.append_current_time_to_date(created_at)
      end
      if ended_at == ENDED_AT_DEFAULT
        params[:user_location][:ended_at] = nil
      else
        params[:user_location][:ended_at] = UserLocation.append_current_time_to_date(ended_at)
      end
    else
      bypass = true
    end
    respond_to do |format|
      if (bypass || @user_location.update_attributes(params[:user_location]))
        @user_locations = current_user.ordered_locations(params[:page])
        @user = current_user
        flash[:notice] = "Checkin Saved"
        format.html { redirect_to user_user_location_path(current_user.slug, @user_location.slug) }
        format.json { head :no_content }
        format.js
      end
    end
  end

  def update_privacy
    @user_location = UserLocation.find(params[:user_location_id])
    if (@user_location.update_attributes(params[:user_location]))
      #@user_locations = current_user.ordered_locations(params[:page])
      #@user = current_user
      respond_to do |format|
        format.json { head :no_content }
      end
    else
    end
  end
  
  def update_user
    email_sms_parents = params[:email_sms_parents]
    email_sms_friends = params[:email_sms_friends]
    sms_email_enabled = (email_sms_parents == "1" || email_sms_friends == "1")
    facebook_enabled = (params[:post_to_facebook] == "1")
    twitter_enabled = (params[:post_to_twitter] == "1")
    send_overrides = {facebook_override: facebook_enabled, twitter_override: twitter_enabled, sms_override: sms_email_enabled, email_override: sms_email_enabled}
    user = User.find(params[:user_id])
    if (user.update_attributes(params[:user].merge({completed_first_checkin:true, send_overrides:send_overrides})))
      user.notification_contact_details.reload
      user.post_notifications(current_user.current_location)
      flash[:notice] = "Your information has been saved."
      respond_to do |format|
        format.html { redirect_to "#{user_user_location_path(current_user.slug, user.current_location.slug)}?step=2"  }
        format.js
      end
    else
      setup_show
      render action: "show"
    end
  end
  
  def destroy
    prior_location = current_user.second_most_recent_place
    prior_location.update_attributes(current: true) if prior_location
    @user_location.destroy

    respond_to do |format|
      @user_locations = current_user.ordered_locations(params[:page]) 
      @user = current_user
      format.json { render text: "Success", status: 200 }
      format.js
    end
  end

  def save_user_client_location
    session[:user_client_location] = params[:user_client_location]
    respond_to do |format|
      format.json
    end
  end

  def ask_for_advice
    user_location = UserLocation.find(params[:id])
    respond_to do |format|
      if (params[:user_provider_friend][:email] && user_location)
        NotificationMailer.delay.invite_to_comment(current_user, params[:user_provider_friend][:email], user_location)
        format.json { head :no_content }
      else
        errors = []
        errors << "Invalid email" unless params[:user_provider_friend][:email]
        errors << "Invalid checkin" unless user_location
        format.json { render json: {errors: errors.join(', ')}, status: :unprocessable_entity }
      end
    end
  end
  
  protected 
    def validate_user
      @user_location = UserLocation.find(params[:id])
      if (@user_location.user_id != current_user.id)
        respond_to do |format|
          format.json { render text: "Error", status: 404 }
        end
      end
    end
end
