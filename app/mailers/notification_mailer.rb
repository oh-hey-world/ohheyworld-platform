class NotificationMailer < ActionMailer::Base
  default from: "Oh Hey World <#{DEFAULT_EMAIL}>"

  def response_to_email_checkin(user_location, success)
    @success = success
    @user_location = user_location
    user = user_location.user
    mail(to: "#{user.user_name} <#{user.email}>", subject: "OHW Checkin")
  end

  def ohw_users_with_same_interest_location(user_location, matching_tags)
    @user_location = user_location
    @matching_tags = matching_tags
    mail(to: "#{user.user_name} <#{user.email}>", subject: "OHW People with same interests")
  end
  
  def arrival_email(user_location, notification_contact)
    user = user_location.user
    location = user_location.location
    @user_location = user_location
    mail(to: "#{notification_contact.name} <#{notification_contact.value}>", subject: "#{user.user_name} just arrived in #{location.name}")
  end

  def request_beta_access(email)
    @email = email
    mail(to: DEFAULT_CONTACT_EMAIL, subject: 'Beta Access Request')
  end

  def send_contact_email(user_contact)
    @message = user_contact.message
    @user = user_contact.user
    mail(to: user_contact.contact.email, subject: user_contact.subject)
  end
  
  def welcome_email(user)
    mail(to: "#{user.user_name} <#{user.email}>", subject: "Welcome to the Oh Hey World Private Beta")
  end

  def invite_to_ohw(user, email)
    @user = user
    mail(to: email, subject: "Oh Hey World Invitation from #{user.user_name}")
  end

  def invite_to_comment(user, email, user_location)
    @user = user
    @user_location = user_location
    mail(to: email, subject: "Oh Hey World Advice Request from #{user.user_name}")
  end

  def send_checkin_comment(user_location, comment)
    @user_location = user_location
    @user = user_location.user
    @comment = comment
    mail(to: "#{@user.user_name} <#{@user.email}>", subject: "Oh Hey World Comment on your Checkin")
  end

  def send_checkin_vote(user_location, voter)
    @user_location = user_location
    @user = user_location.user
    @voter = voter
    mail(to: "#{@user.user_name} <#{@user.email}>", subject: "Oh Hey World Like on your Checkin")
  end
  
  def dev_test_email(message)
    @message = message
    mail(to: "eric.roland@gmail.com", subject: "ohheyworld message", )
  end
end
