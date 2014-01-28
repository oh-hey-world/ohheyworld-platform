module UsersHelper
  def checked_preference(name, value)
    {checked: (User.preference_true?(name, value))}
  end
  
  def preference_true?(name, value)
    (User.preference_true?(name, value))
  end
  
  def checked_preference_valid(name, value)
    (User.preference_true?(name, value) && current_user.provider_valid?(name))
  end
  
  def curent_location_profile(user)
    (user.current_location) ? "#{user.current_location.location.name} for #{distance_of_time_in_words_to_now(user.current_location.created_at)}" : "Undisclosed"
  end
  
  def last_residence_location_profile(user)
    (user.home_location)  ? "#{user.home_location.name}" : "Undisclosed"
  end
  
  def first_time_aborad_profile(user)
    first_location_abroad = user.first_time_abroad
    (first_location_abroad) ? first_location_abroad.created_at.strftime("%Y") : "Undisclosed"
  end
  
  def user_profile_blurb(user)
    (user.blurb.blank?) ? "Undisclosed" : user.blurb
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
