Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FACEBOOK_KEY, FACEBOOK_SECRET, 
    {:scope => 'user_location,friends_location,publish_stream,email,offline_access,user_birthday,user_about_me',
      :client_options => {:ssl => {:ca_file => "/etc/ssl/certs/ca-certificates.crt"}}}
  provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
end