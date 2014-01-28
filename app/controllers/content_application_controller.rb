class ContentApplicationController < ApplicationController
  before_filter :require_admin_or_content

  def require_admin_or_content
    if !user_signed_in? || !current_user.is_allowed_content_creation?
      permission_denied
    else
      @in_content_creation = true
    end
  end
end