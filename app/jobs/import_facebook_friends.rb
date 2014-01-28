class ImportFacebookFriends
  
  attr_accessor :options

  def initialize(options = {})
    @options = options
  end

  def perform
    provider = options[:provider]
    user = options[:user]
    begin
      User.save_friends(provider.provider_token, provider.provider, user)
      user.update_attributes(import_job_finished_at: Time.current, import_job_id: nil)
    rescue Exception => e
      Rails.logger.error e
    end
  end

end