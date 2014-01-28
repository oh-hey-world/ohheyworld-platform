class Api::UserAssetsController < Api::BaseController
  before_filter :authenticate_user!

  def index
    @user_assets = current_user.user_assets
  end

  def create
    if params["userId"].to_i == current_user.id
      UserAsset.update_all(default: false)
      user_asset = UserAsset.create(user_id: params[:userId], default: params[:isDefault], type: params[:type], asset: params[:asset])
    end
    if (user_asset)
      @user_assets = [user_asset]
    else
      errors = user_asset.errors if user_asset
      render json: {success:false, message: errors, status: :unprocessable_entity}
    end
  end
end
