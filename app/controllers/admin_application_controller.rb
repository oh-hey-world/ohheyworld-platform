class AdminApplicationController < ApplicationController
  before_filter :require_admin
  
  def require_admin
    if !user_signed_in? || !current_user.is?('admin')
      permission_denied
    else
      @in_admin = true
    end
  end
end