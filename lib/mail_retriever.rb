class MailRetriever
  class << self
    def get_mail
      Mail.defaults do
        retriever_method :pop3, :address => 'mail.ohheyworld.com',
                         :user_name  => EMAIL_CHECKIN_USER,
                         :password   => EMAIL_CHECKIN_PASSWORD
        delivery_method  :smtp,    :openssl_verify_mode  => 'none',
                         :domain          => "ohheyworld.com",
                         :address         => 'mail.ohheyworld.com',
                         :authentication  => :plain,
                         :port            => 587,
                         :user_name       => 'support@ohheyworld.com',
                         :password        => 'uGCagnaF'
      end

      emails = Mail.find(what: :first, count: 1000, order: :asc, delete_after_find: true)
      emails.each { |mail|
        begin
          @user = User.find_by_email(mail.from.first)
          if (@user)
            user_input = mail.text_part.subject.decoded
            location = Location.find_or_create_by_user_input(user_input)
            if location
              current_location = @user.current_location.location
              if (current_location.state_id == location.state_id && current_location.country_id == location.country_id && current_location.city_id == location.city_id )
                @user_location = @user.current_location
              else
                custom_message = (mail.text_part.body.decoded.blank?) ? nil : mail.text_part.body.decoded
                @user_location = UserLocation.new(location_id: location.id, user_id: @user.id, source: 'email', custom_message: custom_message)
                if (@user_location.save)
                  @user.post_notifications(@user_location) if @user_location && @user.completed_first_checkin
                end
              end
              @success = (@user && @user_location && (@user_location.persisted? || @user_location.prior_location_id))
            end

            NotificationMailer.response_to_email_checkin(@user_location, @success).deliver
          end
        rescue Exception => e
          Rails.logger.info e
        end
      }
    end
  end
end