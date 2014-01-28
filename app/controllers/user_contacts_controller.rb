class UserContactsController < ApplicationController
  def create
    user_contact = UserContact.new(params[:user_contact])
    user_contact.email = user_contact.contact.email
    user_contact.subject = "Contact from #{current_user.user_name} via Oh Hey World"
    if user_contact.save
      NotificationMailer.delay.send_contact_email(user_contact)
      respond_to do |format|
        format.js { render json: user_contact, content_type: 'text/json' }
      end
    end
  end
end
