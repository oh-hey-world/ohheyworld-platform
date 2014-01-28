class UserCitiesController < ContentApplicationController
  before_filter :set_up_staff_pick, only: [:create, :update]
  skip_before_filter :require_admin_or_content, only: :city_tips
  skip_before_filter :require_login, only: :city_tips
  # GET /user_cities
  # GET /user_cities.json
  def index
    @user_cities = UserCity.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_cities }
    end
  end

  def city_tips
    @city = City.find(params[:city_id])
    @users = User.with_tips_for_city(@city.id, params[:page])
    @path_minimum_parameters = city_tips_path(params[:city_id])
    if params[:user_id]
      @selected_user = User.find(params[:user_id])
      @user_city = UserCity.find_by_user_id_and_city_id(@selected_user.id, @city.id) if @selected_user && @city
    else
      if @city
        @user_city = UserCity.find_by_user_id_and_city_id(nil, @city.id) unless (params[:community] == 'true')
        if @users && !@user_city
          @selected_user = @users.first
          user_id = (@selected_user) ? @selected_user.id : nil
          @user_city = UserCity.find_by_user_id_and_city_id(user_id, @city.id)
        end
      end
    end
    if @city && @user_city
      if params[:travel_profile] && params[:travel_profile].size > 0
        @user_city_tips = @user_city.user_city_tips.where(travel_profile: params[:travel_profile]).page(params[:page])
      else
        @user_city_tips = @user_city.user_city_tips.page(params[:page])
      end
      @travel_profiles = UserCityTip.distict_travel_profiles(@user_city).map(&:travel_profile).compact
      @travel_profiles_for_select = UserCityTip::TRAVEL_PROFILE_TYPES.map{ |x| [x.humanize.titleize, x] if @travel_profiles.include?(x) }
      @travel_profiles_for_select.compact!
    end
    @grouped_tips, @first_profile = UserCityTip.group_tips_by_tag(@user_city_tips)
    @first_profile = params[:travel_profile] if params[:travel_profile]
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  # GET /user_cities/1
  # GET /user_cities/1.json
  def show
    @user_city = UserCity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_city }
    end
  end

  # GET /user_cities/new
  # GET /user_cities/new.json
  def new
    @user_city = UserCity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_city }
    end
  end

  # GET /user_cities/1/edit
  def edit
    @user_city = UserCity.find(params[:id])
  end

  # POST /user_cities
  # POST /user_cities.json
  def create
    @user_city = UserCity.new(params[:user_city])

    respond_to do |format|
      if @user_city.save
        format.html { redirect_to @user_city, notice: 'User city was successfully created.' }
        format.json { render json: @user_city, status: :created, location: @user_city }
      else
        format.html { render action: "new" }
        format.json { render json: @user_city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_cities/1
  # PUT /user_cities/1.json
  def update
    @user_city = UserCity.find(params[:id])

    respond_to do |format|
      if @user_city.update_attributes(params[:user_city])
        format.html { redirect_to @user_city, notice: 'User city was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_cities/1
  # DELETE /user_cities/1.json
  def destroy
    @user_city = UserCity.find(params[:id])
    @user_city.destroy

    respond_to do |format|
      format.html { redirect_to user_cities_url }
      format.json { head :no_content }
    end
  end

  def set_up_staff_pick
    params[:user_city][:user_id] = nil if params[:staff_city]
  end
end
