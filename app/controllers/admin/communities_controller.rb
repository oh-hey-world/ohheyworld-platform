class Admin::CommunitiesController < AdminApplicationController

  def new
    @community = Community.new
  end

  def create
    @community = Community.create(params[:community])
    if @community.save
      flash[:notice] = "Community created."
      redirect_to admin_users_path
    else
      flash[:alert] = "Community not created."
      render :new
    end
  end
end
