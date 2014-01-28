# Load the rails application
require File.expand_path('../application', __FILE__)
require_relative File.join('../lib/core_ext', 'rails_extensions')

# Initialize the rails application
Web::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => "ohheyworld",
  :password => "W0rldTr@veler",
  :domain => "ohheyworld.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
