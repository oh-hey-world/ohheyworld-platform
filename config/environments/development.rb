Web::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.console = true
  end

end

BASE_URL = "localhost:3000"
FACEBOOK_KEY = '208943589120128'
FACEBOOK_SECRET = '64ac629b302425f5468e067cafe5ae8c'
TWITTER_CONSUMER_KEY = 'mMTRvMDNhw4bJDKnrJmA'
TWITTER_CONSUMER_SECRET = 'PA9AeCpO31ialPVVyAG1q9ixU4h04ZITM0Evcuu7Ur4'
BING_GEOCODER_KEY = 'AuFOCnKRkw22FU0GD_fvqudUo7iW5iX6-o6ZdWUt-ce3cb9Xe0w4xwpVAjQNYFPB'
EMAIL_CHECKIN_USER = 'dev2@ohheyworld.com'
EMAIL_CHECKIN_PASSWORD = 'B?egnCMs'

Paperclip.options[:command_path] = '/usr/local/bin/'
Rails.application.routes.default_url_options[:host] = BASE_URL