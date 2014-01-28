class Api::SessionsController < Api::BaseController
  before_filter :authenticate_user!, :except => [:create, :destroy]
  before_filter :ensure_params_exist
  
  def create
    app_id_matches = (request.headers['X-APP-ID'] == FACEBOOK_APP_ID)
    if app_id_matches
      @user = User.find_for_database_authentication(:email => params["user"]["email"])
      @user = User.create_with_client(params["user"]) unless @user
    end
    if @user
      sign_in(:user, @user)
      @user.ensure_authentication_token!
      #render :json=> {:success=>true, :auth_token=>resource.authentication_token, :user=>resource}
      return
    end
    invalid_login_attempt
  end

  def destroy
    resource = User.find_for_database_authentication(:email => params["user"]["email"])
    resource.authentication_token = nil
    resource.save
    render :json=> {:success=>true}
  end

  protected
  def ensure_params_exist
    return unless params["user"]["email"].blank?
    render :json=>{:success=>false, :message=>"missing user parameter"}, :status=>422
  end

  def invalid_login_attempt
    render :json=> {:success=>false, :message=>"Error with your login"}, :status=>401
  end
end