class UserLocationTaggedUsersController < ApplicationController
  # GET /user_location_tagged_users
  # GET /user_location_tagged_users.json
  def index
    @user_location_tagged_users = UserLocationTaggedUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_location_tagged_users }
    end
  end

  # GET /user_location_tagged_users/1
  # GET /user_location_tagged_users/1.json
  def show
    @user_location_tagged_user = UserLocationTaggedUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_location_tagged_user }
    end
  end

  # GET /user_location_tagged_users/new
  # GET /user_location_tagged_users/new.json
  def new
    @user_location_tagged_user = UserLocationTaggedUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_location_tagged_user }
    end
  end

  # GET /user_location_tagged_users/1/edit
  def edit
    @user_location_tagged_user = UserLocationTaggedUser.find(params[:id])
  end

  # POST /user_location_tagged_users
  # POST /user_location_tagged_users.json
  def create
    @user_location_tagged_user = UserLocationTaggedUser.new(params[:user_location_tagged_user])
    if @user_location_tagged_user.user_location.user.id == current_user.id
      respond_to do |format|
        if @user_location_tagged_user.save
          #@user_location_tagged_user.friend_name = (@user_location_tagged_user.user) ? @user_location_tagged_user.user.user_name : @user_location_tagged_user.provider_friend.user_name
          @provider_friend = @user_location_tagged_user.provider_friend
          @user = @user_location_tagged_user.user
          format.html { redirect_to @user_location_tagged_user, notice: 'User location tagged user was successfully created.' }
          format.json
        else
          format.html { render action: "new" }
          format.json { render json: @user_location_tagged_user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /user_location_tagged_users/1
  # PUT /user_location_tagged_users/1.json
  def update
    @user_location_tagged_user = UserLocationTaggedUser.find(params[:id])
    if @user_location_tagged_user.user_location.user.id == current_user.id
      respond_to do |format|
        if @user_location_tagged_user.update_attributes(params[:user_location_tagged_user])
          format.html { redirect_to @user_location_tagged_user, notice: 'User location tagged user was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user_location_tagged_user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /user_location_tagged_users/1
  # DELETE /user_location_tagged_users/1.json
  def destroy
    @user_location_tagged_user = UserLocationTaggedUser.find(params[:id])
    if @user_location_tagged_user.user_location.user.id == current_user.id
      @user_location_tagged_user.destroy
    end

    respond_to do |format|
      format.html { redirect_to user_location_tagged_users_url }
      format.json { head :no_content }
      format.js { render json: nil, content_type: 'text/json' }
    end
  end
end
