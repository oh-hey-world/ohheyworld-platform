class UserProviderFriendsController < ApplicationController
  def update
    user_provider_friend = UserProviderFriend.find(params[:id])

    if user_provider_friend.user_id == current_user.id
      if user_provider_friend.provider_friend && user_provider_friend.provider_friend.user
        friend_id = user_provider_friend.provider_friend.user.id
        user_friend = UserFriend.where(user_id: current_user.id, friend_id: friend_id).first
      end
      if params[:commit] == "Follow" || params[:commit] == "Unfollow"
        provider_success = user_provider_friend.update_attributes(following: (!user_provider_friend.following))
      else
        provider_success = user_provider_friend.update_attributes(params[:user_provider_friend])
        NotificationMailer.delay.invite_to_ohw(current_user, "#{user_provider_friend.provider_friend.user_name} <#{user_provider_friend.email}>")
      end
      if user_provider_friend.following
        UserFriend.create(user_id: current_user.id, friend_id: friend_id) if friend_id && !user_friend
      else
        user_friend.destroy if user_friend
      end
    end

    respond_to do |format|
      if provider_success
        format.json { head :no_content }
      else
        format.json { render json: user_provider_friend.errors, status: :unprocessable_entity }
      end
    end
  end

  def follow
    @new_user = User.new
    @user_provider_friends = UserProviderFriend.my_friends_to_follow(current_user, params[:page])
  end
end
