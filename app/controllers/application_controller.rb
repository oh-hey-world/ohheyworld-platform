class ApplicationController < ActionController::Base
  #check_authorization :unless => :devise_controller?
  skip_authorization_check if: :devise_controller?
  before_filter :setup, :prepare_for_mobile
  before_filter :require_login, unless: :devise_controller?
  protect_from_forgery
  
  def setup
    if user_signed_in?
      if (current_user.provider('facebook') && !current_user.provider_valid?('facebook') &&
        ![users_auth_facebook_callback_path, users_auth_facebook_setup_path, users_auth_facebook_path].include?(request.path) && !session[:impersonating])
        redirect_to users_auth_facebook_path
      end
      if session[:organization_tags]
        user = User.find(current_user.id)
        user.interest_list = session[:organization_tags]
        user.save
        session[:organization_tags] = nil
      end
      @new_user_search = current_user.user_searches.build
      @unique_friend_tags = current_user.unique_tags
    end
    session[:registration_code] = params[:registration_code] if params[:registration_code]
    session[:organization_tags] = params[:organization_tags] if params[:organization_tags]
    @new_user_location = (current_user) ? current_user.user_locations.build(private: current_user.checkins_default_private.value == "1") : UserLocation.new
  end
  
  def require_login
    if !user_signed_in?
      permission_denied
    end
  end
  
  def permission_denied
    store_location
    flash[:error] = "Sorry, you are not allowed to access that page.  This is a closed beta."
    redirect_to root_path
  end
  
  helper_method :is_same_user?

  def is_same_user?(user=nil)
    other_user = (user) ? user : @user
    (user_signed_in? && other_user && other_user.id == current_user.id)
  end
  
  def http_authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name == "test" && password == "me"
    end
    warden.custom_failure! if performed?
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def current_user
    @current_user ||= super && User.includes(:user_providers).find(@current_user.id)
  end
  
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      match = (request.user_agent =~ /Mobile|webOS|iPhone/)
      (match && match >= 0)
    end
  end

  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    #request.format = :mobile if mobile_device? #don't for mobile for all
  end

  def set_menu_hidden
    @hide_logged_out = true
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_stored_location
    session[:return_to] = nil
  end

  def redirect_back_or_to(alternate)
    redirect_to(session[:return_to] || alternate)
    clear_stored_location
  end
end
