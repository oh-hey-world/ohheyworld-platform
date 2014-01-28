class Api::UsersController < Api::BaseController  
  respond_to :json

  def update
    respond_to do |format|
      if resource.update_attributes(params[:user])
        format.json { head :no_content }
      else
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @users = [User.find(params[:id])]
  end

  def badge
    @user = User.find(params[:id])
  end
end