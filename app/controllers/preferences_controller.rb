class PreferencesController < ApplicationController
  
  def index
  end

  def create
    @preference = Preference.create(params[:preference])
    if (@preference.save)
      redirect_to user_location_path(params[:user_location_id]), notice: 'Your answer was successfully saved.'
    else
      redirect_to user_location_path(params[:user_location_id])     
    end
  end
  
  def update
    #TODO fix - kludgy for now unsure how we want to display views, do bother the user with errors for now
    @preference = Preference.find(params[:id])
    if (@preference.update_attributes(params[:preference]))
      redirect_to user_location_path(params[:user_location_id]), notice: 'Your answer was successfully saved.'
    else
      redirect_to user_location_path(params[:user_location_id])
    end
  end

  def show
  end
end
