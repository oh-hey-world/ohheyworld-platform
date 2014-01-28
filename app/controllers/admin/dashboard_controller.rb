class Admin::DashboardController < ApplicationController
  def index
    @slugged_users = User.slugged(params[:users_page])
    @user_checkins = UserLocation.checkins(params[:checkins_page])
  end
end
