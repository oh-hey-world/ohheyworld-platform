class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is?("admin")
      can :manage, :all
    elsif user.is?("standard")
      can :manage, [User, UserLocation, Location, Preference, UserCountry, UserLanguage, UserProvider, ProviderFriend, UserProviderFriend]
      can :read, :all
      cannot :edit, Community
    else
      can :read, :all
    end
  end
end
