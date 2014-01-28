class UserCityTipsController < ContentApplicationController
  skip_before_filter :require_admin_or_content, only: :like_city_tip

  def like_city_tip
    @user_city_tip = UserCityTip.find(params[:id])
    respond_to do |format|
      if @user_city_tip.liked_by current_user
        format.js { render json: {'number_of_likes' => @user_city_tip.likes.size}.to_json, content_type: 'text/json' }
      else
        format.js { render json: @user_city_tip, status: :unprocessable_entity }
      end
    end
  end

  # GET /user_city_tips
  # GET /user_city_tips.json
  def index
    @user_city_tips = UserCityTip.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_city_tips }
    end
  end

  # GET /user_city_tips/1
  # GET /user_city_tips/1.json
  def show
    @user_city_tip = UserCityTip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_city_tip }
    end
  end

  # GET /user_city_tips/new
  # GET /user_city_tips/new.json
  def new
    @user_city_tip = UserCityTip.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_city_tip }
    end
  end

  # GET /user_city_tips/1/edit
  def edit
    @user_city_tip = UserCityTip.find(params[:id])
  end

  # POST /user_city_tips
  # POST /user_city_tips.json
  def create
    unless params[:user_city_tip][:user_city_id]
      user_id = (params[:user_id] == "") ? nil : params[:user_id]
      @user_city = UserCity.find_or_create_by_city_id_and_user_id(params[:city_id], user_id)
      params[:user_city_tip][:user_city_id] = @user_city.id
    end
    @user_city_tip = UserCityTip.new(params[:user_city_tip])

    respond_to do |format|
      if @user_city_tip.save
        format.html { redirect_to @user_city_tip, notice: 'User city tip was successfully created.' }
        format.json { render json: @user_city_tip, status: :created, location: @user_city_tip }
      else
        format.html { render action: "new" }
        format.json { render json: @user_city_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_city_tips/1
  # PUT /user_city_tips/1.json
  def update
    @user_city_tip = UserCityTip.find(params[:id])

    respond_to do |format|
      if @user_city_tip.update_attributes(params[:user_city_tip])
        format.html { redirect_to @user_city_tip, notice: 'User city tip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_city_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_city_tips/1
  # DELETE /user_city_tips/1.json
  def destroy
    @user_city_tip = UserCityTip.find(params[:id])
    @user_city_tip.destroy

    respond_to do |format|
      format.html { redirect_to user_city_tips_url }
      format.json { head :no_content }
    end
  end
end
