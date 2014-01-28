class UsersController < ApplicationController
  skip_authorize_resource :only => [:index, :profile, :registration_code, :tags, :more_people_with_tags, :more_locations]
  skip_before_filter :require_login, :except => [:edit, :update, :destroy, :new, :create, :import_facebook_friends, :update_profile, :settings, :impersonate, :tag_notifications]
  inherit_resources
  actions :all, :except => [ :edit, :update, :destroy, :new, :create ]
  before_filter :set_menu_hidden, :only => [:registration_code, :awaiting_confirmation]
  before_filter :setup_profile, :only => [:show, :profile]
  before_filter :find_friend, only: [:update_friend_profile_tag, :update_friend_tag]
  before_filter :people_with_tags, only: [:tags, :more_people_with_tags]
  
  def index
    @user_location = current_user.most_recent_place if current_user
  end
  
  def registration_code
  end

  def travelblog
    redirect_to "#{BLOG_URL}/#{params[:slug]}", status: 301
  end

  def enter_registration_code
    unless params[:registration_code].blank?
      session[:registration_code] = params[:registration_code]
      session[:failed_beta] = false
      if session[:sign_in_type] == 'twitter'
        redirect_to users_auth_twitter_path
      else
        redirect_to users_auth_facebook_path
      end
    else
      redirect_to users_registration_code_path
    end
  end
  
  def checkin
    if (user_signed_in?)
      facebook_enabled = (params[:user][:preferences][:facebook] == "1")
      twitter_enabled = (params[:user][:preferences][:twitter] == "1")
      send_overrides = {facebook_override: facebook_enabled, twitter_override: twitter_enabled, sms_override: true, email_override: true}
      params[:user].delete(:preferences)
      @new_user_location = UserLocation.new(params[:user][:user_location])
      @new_user_location.source = 'web'
      @new_user_location.save
      params[:user].delete(:user_location)
      resource.update_attributes(params[:user].merge({send_overrides:send_overrides}))
      if (@new_user_location.persisted? || @new_user_location.prior_location_id)
        if @new_user_location.prior_location_id
          @new_user_location = UserLocation.find(@new_user_location.prior_location_id) 
          @new_user_location.update_attribute(:current, true) #this fixes the issue of users who check into their home town the first time
        end
        @second_most_recent_place = resource.second_most_recent_place
        @second_most_recent_place.update_attribute(:ended_at, @new_user_location.created_at) if @second_most_recent_place && @second_most_recent_place.ended_at.blank?
        resource.notification_contact_details.reload
        resource.post_notifications(@new_user_location) if @new_user_location && resource.completed_first_checkin
        respond_to do |format|
          @user_locations = resource.ordered_locations(params[:page])
          @user = resource
          flash[:notice] = "You've checked in to #{@new_user_location.name}!"
          format.html {redirect_to user_user_location_path(resource.slug, @new_user_location.slug)}
          format.js
        end
      else
        respond_to do |format|
          format.html {render action: "index"}
          format.js { render json: @new_user_location, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def auth_callback
  end

  def awaiting_confirmation

  end
  
  def update_tags
    if (resource.update_attributes(params[:user]))
      respond_to do |format|
        format.js { render json: resource, content_type: 'text/json' }
        format.html { redirect_to profile_user_path(resource), notice: "Saved!" }
      end
    else
      respond_to do |format|
        format.html {render action: "profile"}
        format.js { render json: resource, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    if params[:user][:preferences]
      preferences = params[:user][:preferences]
      preferences.each do |preference|
        resource.write_preference(preference[0], preference[1])
      end
    end
    params[:user].delete(:preferences)
    contacts = params[:user][:notification_contact_details_attributes]
    contacts.each do |contact|
      params[:user][:notification_contact_details_attributes].delete contact[0] if contact[1][:name].blank? || contact[1][:value].blank?
    end
    if (resource.update_attributes(params[:user]))
      flash[:notice] = "Saved!"
      respond_to do |format|
        format.html { redirect_to (params[:privacty_settings]) ? privacy_user_path(current_user) : settings_user_path(resource)  }
        format.js
      end
    else
      flash[:error] = resource.errors.empty? ? "" : resource.errors.full_messages.to_sentence
      render action: (params[:privacty_settings]) ? "privacy" : "settings"
    end
  end
  
  def checkin_step_2
    
  end
  
  def new_parents_settings
    sms_and_email_parents = params[:user][:preferences][:sms_and_email_parents]
    resource.write_preference("sms_friends", sms_and_email_parents)
    resource.write_preference("email_friends", sms_and_email_parents)
  end
  
  def new_parents
    if (resource.update_attributes(params[:user]))
      flash[:notice] = "Saved!"
      respond_to do |format|
        format.html { redirect_to settings_user_path(resource)  }
        format.js
      end
    end
  end
  
  def reset_completed_first_checkin
    if resource
      resource.update_attribute(:completed_first_checkin, false)
      redirect_to root_path
    end
  end
  
  def import_facebook_friends
    resource.import_facebook_friends
    respond_to do |format|
      format.json {
        render :json => "{success: true}"
      }
    end
  end
  
  def import_facebook_friends_finished
    if current_user && current_user.import_job_finished?
      @provider_friends = ProviderFriend.user_friends_not_ohw_user(current_user, current_user.current_location.location, false, params[:friends_page])
      @current_location = current_user.current_location.location if current_user.current_location
    end
    respond_to do |format|
      format.js
    end
  end

  def show

  end
  
  def profile

  end

  def setup_profile
    @user = User.find(params[:id])
    @user = User.where(email: params[:id]).first unless @user
    @user_cities = UserCity.unique_cities(@user.id)
    @countries_visited = @user.countries_visited
    @total_days_traveled = @user.total_days_traveled
    @user_locations = @user.ordered_locations(is_same_user?, params[:page])
    @followers_count = UserFriend.followers_count(@user)
    @following_count = UserFriend.following_count(@user)
    if current_user && !is_same_user?
      @friend_relationship = UserFriend.friend_relationship(current_user, @user)
    end
  end


  def more_locations
    if current_user
      @user = User.find(params[:id])
      @user_locations = current_user.ordered_locations(is_same_user?, params[:page])
    end
  end
  
  def edit
    
  end
  
  def network

  end
  
  def new_notification_contact_details
    if current_user
      @notification_placeholder_value = params[:placeholder_value]
      @notification_type = params[:notification_type]
      @notification_show_enabled = params[:notification_show_enabled]
      @notification_contact_detail = current_user.notification_contact_details.build
      respond_to do |format|
        format.js
      end
    end
  end
  
  def update_profile
    if params[:user][:preferences]
      preferences = params[:user][:preferences]
      preferences.each do |preference|
        resource.write_preference(preference[0], preference[1])
      end
    end
    params[:user].delete(:preferences)
    @home_location = Location.find_or_create_by_user_input(params[:user][:home_location][:user_input])
    user = User.find(resource.id)
    user.home_location = @home_location
    params[:user].delete(:home_location)
    params[:user].delete(:user_assets_attributes) unless params[:user][:user_assets_attributes].first[1][:asset]
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if (user.update_attributes(params[:user])) #TODO review security authorization
      unless params[:user][:password].blank?
        sign_in user, :bypass => true
      end
      redirect_to profile_user_path(user), notice: "Saved!"
    else
      flash[:error] = "Error saving your profile #{user.errors.full_messages.join(' ')}"
      render action: "edit"
    end
  end
  
  def privacy
  end
  
  def privacy
    authorize_preferences
  end

  def settings
    authorize_preferences
    @countries = Country.with_phone_codes
    if (params[:remove_provider])
      current_user.provider(params[:remove_provider]).destroy
      respond_to do |format|
        flash[:notice] = "Successfully removed #{params[:remove_provider].capitalize} authentication!"
        format.html {redirect_to settings_user_path(current_user)}
      end
    end
  end
  
  def authorize_preferences
    authorize! :manage, Preference
    @notification_preferences = current_user.notification_preferences if current_user
  end

  def tag_notifications
    @user = resource
    current_tags = @user.user_tag_notifications.map(&:tag)
    @user.interest_list.each do |interest_tag|
      @user.user_tag_notifications.create(tag: interest_tag) unless current_tags.include?(interest_tag)
    end
    @user.user_tag_notifications.build
  end

  def update_tag_notifications
    @user = resource
    if @user.update_attributes(params[:user])
      @user.user_tag_notifications.build
      respond_to do |format|
        flash[:notice] = "Your information has been saved."
        format.html { redirect_to tag_notifications_user_path(@user) }
      end
    else
      respond_to do |format|
        @errors = @user.errors
        format.html {render action: "tag_notifications"}
      end
    end
  end

  def lists
    tag = params[:tag]
    unless params[:friends_page]
      @user_provider_friends = UserProviderFriend.my_friends_followed_not_ohw(current_user, tag, params[:provider_friends_page])
    end
    unless params[:provider_friends_page]
      @user_friends = UserFriend.user_friends_by_tag(current_user, tag, params[:friends_page])
    end
  end

  def update_friend_tag
    if params[:person_type] == UserProviderFriend.to_s
      @friend = UserProviderFriend.find_by_user_id_and_provider_friend_id(current_user.id, params[:relationship_id])
    else
      @friend = UserFriend.find_by_user_id_and_friend_id(current_user.id, params[:relationship_id])
    end
    if params[:commit] == "Remove"
      @friend.tag_list.remove(params[:tag])
    else
      @friend.tag_list << params[:tag]
    end
    @friend.save
    respond_to do |format|
      format.js
    end
  end

  def update_friend_profile_tag
    #user_friend"=>{"tag_list"=>"family, close friends"}, "person_type"=>"UserFriend", "relationship_id"=>"3", "commit"=>"Save", "id"=>"drewmeyers"
    if params[:commit] == "Save"
      @friend.tag_list = params[:user_friend][:tag_list]
    end
    @friend.save
  end
  
  def impersonate
    if current_user.is?('admin')
      session[:impersonating] = true
      @user = User.find params[:id ] 
      sign_out :user if current_user 
      sign_in @user 
    end
    redirect_to root_path 
  end

  def tags
    @user_friends = UserFriend.friends_in_clause(current_user, @users.map(&:id)) if current_user
    if (@users && (@incoming_list && @perma_list != @incoming_list))
      redirect_to action: :tags, perma_list: @list
    end
  end

  def more_people_with_tags

  end

  def people_with_tags
    @perma_list = params[:perma_list]
    @incoming_list = params[:list]
    @list = (@incoming_list) ? @incoming_list : @perma_list
    @users = User.closest_with_tags(current_user, @list, params[:page])
  end

  protected
    def find_friend
      if params[:person_type] == UserProviderFriend.to_s
        @friend = UserProviderFriend.find_by_user_id_and_provider_friend_id(current_user.id, params[:relationship_id])
      else
        @friend = UserFriend.find_by_user_id_and_friend_id(current_user.id, params[:relationship_id])
      end
    end
end
