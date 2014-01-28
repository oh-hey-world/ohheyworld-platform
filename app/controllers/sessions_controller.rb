class SessionsController < Devise::SessionsController
  before_filter :set_menu_hidden

  # POST /resource/sign_in
  def create
    super
    #redirect_back_or_to(root_path)
  end

  def destroy
    super
    session[:registration_code] = nil
  end
end