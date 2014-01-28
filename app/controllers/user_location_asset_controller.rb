class UserLocationAssetController < ApplicationController
  def destroy
    @user_location_asset = UserLocationAsset.find(params[:id])
    @user_location_asset.destroy

    respond_to do |format|
      format.js { render json: nil, content_type: 'text/json' }
    end
  end
end
