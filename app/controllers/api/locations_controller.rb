class Api::LocationsController < Api::BaseController
  before_filter :authenticate_user!
  respond_to :json
  
  def search
    locations = [Location.find_or_create_by_user_input(params[:user_input])]
    render :json=> {:success=>true, :locations=>locations}
  end
  
  def create
  end
  
  def show
    
  end
end