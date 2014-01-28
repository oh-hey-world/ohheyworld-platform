class TwilioController < ApplicationController
  skip_authorize_resource :only => [:process_sms]
  skip_before_filter :require_login

  def process_sms
    @user = User.find_by_phone(params[:From])
    if (@user)
      user_input = params[:Body]
      #location_input = "#{params[:FromCity]} #{params[:FromState]} #{params[:FromZip]} #{params[:FromCountry]}"
      #(user_input.blank?) ? location_input : user_input
      location = Location.create!(user_input: user_input)
      @new_user_location = UserLocation.create(location_id: location.id, user_id: @user.id, source: 'sms')

      @user.post_notifications(@new_user_location) if @new_user_location && @user.completed_first_checkin
    end
    @success = (@user && (@new_user_location.save || @new_user_location.prior_location_id))

    render 'process_sms.xml.slim', :content_type => 'text/xml'
  end
end
