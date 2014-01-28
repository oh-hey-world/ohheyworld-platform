class Api::UserFriendsController < Api::BaseController
  def index
    @user_friends = current_user.user_friends
  end

  def create
    user_friend = UserFriend.find_or_create_by_friend_id_and_user_id(params["user_friends.user_friend"]) if params["user_friends.user_friend"]["user_id"] == current_user.id
    if (user_friend)
      @user_friends = current_user.user_friends
      render "index"
    else
      errors = user_friends.errors if user_friends
      render json: {success:false, message: errors, status: :unprocessable_entity}
    end
  end

  def destroy
    user_friend = UserFriend.find(params["id"])
    user_friend.destroy if user_friend.user_id == current_user.id

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
