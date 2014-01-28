class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :require_login
  
  def facebook
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    if @user && @user.persisted? && @user.provider_valid?('facebook')
      @user.import_facebook_friends
      session[:failed_beta] = false
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      if @user.confirmed?
        if params[:state] == 'dialog'
          redirect_to auth_callback_user_path(current_user)
        else
          sign_in @user
          redirect_back_or_to(root_path)
        end
      else
        redirect_to users_awaiting_confirmation_path
      end
    else
      flash[:error] = "We were unable to authorize your Beta Status or Registration Code"
      session[:failed_beta] = true
      session[:sign_in_type] = 'facebook'
      redirect_to users_registration_code_path
    end
  end
  
  def twitter
    auth_token = env["omniauth.auth"]
    user_provider = UserProvider.find_twitter_by_auth(current_user, auth_token)
    if (user_provider.save_twitter_auth(auth_token))
      redirect_to auth_callback_user_path(current_user)
    else
      flash[:error] = "We were unable to authorize your Beta Status or Registration Code"
      session[:failed_beta] = true
      session[:sign_in_type] = 'twitter'
      redirect_to users_registration_code_path
    end
  end
end
