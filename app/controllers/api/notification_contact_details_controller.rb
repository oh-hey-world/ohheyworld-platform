class Api::NotificationContactDetailsController < Api::BaseController
  def index
    @notification_contact_details = NotificationContactDetail.where(user_id: current_user.id)
  end

  def create
=begin
    user_friend = UserFriend.find_or_create_by_friend_id_and_user_id(params["user_friends.user_friend"]) if params["user_friends.user_friend"]["user_id"] == current_user.id
    if (user_friend)
      @user_friends = current_user.user_friends
      render "index"
    else
      errors = user_friends.errors if user_friends
      render json: {success:false, message: errors, status: :unprocessable_entity}
    end
=end
  end

  def destroy
=begin
    user_friend = UserFriend.find(params["id"])
    user_friend.destroy if user_friend.user_id == current_user.id

    respond_to do |format|
      format.json { head :no_content }
    end
=end
  end
end
