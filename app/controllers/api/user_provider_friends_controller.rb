class Api::UserProviderFriendsController < Api::BaseController

  def index
    provider = current_user.provider('facebook')
    @user_provider_friends = current_user.user_provider_friends
  end

  def update
    params["user_provider_friends.user_provider_friend"].delete(:provider_friend)
    user_provider_friend = UserProviderFriend.find(params[:id])

    respond_to do |format|
      if user_provider_friend.user_id == current_user.id && user_provider_friend.update_attributes(params["user_provider_friends.user_provider_friend"])
        format.json { head :no_content }
      else
        format.json { render json: user_provider_friend.errors, status: :unprocessable_entity }
      end
    end
  end
end
