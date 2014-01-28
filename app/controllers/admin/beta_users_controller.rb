class Admin::BetaUsersController < AdminApplicationController
  
  # GET /beta_users
  # GET /beta_users.json
  def index
    @beta_users = BetaUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @beta_users }
    end
  end

  # GET /beta_users/1
  # GET /beta_users/1.json
  def show
    @beta_user = BetaUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @beta_user }
    end
  end

  # GET /beta_users/new
  # GET /beta_users/new.json
  def new
    @beta_user = BetaUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @beta_user }
    end
  end

  # GET /beta_users/1/edit
  def edit
    @beta_user = BetaUser.find(params[:id])
  end

  # POST /beta_users
  # POST /beta_users.json
  def create
    @beta_user = BetaUser.new(params[:beta_user])

    respond_to do |format|
      if @beta_user.save
        format.html { redirect_to admin_beta_user_path(@beta_user), notice: 'Beta user was successfully created.' }
        format.json { render json: @beta_user, status: :created, location: @beta_user }
      else
        format.html { render action: "new" }
        format.json { render json: @beta_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /beta_users/1
  # PUT /beta_users/1.json
  def update
    @beta_user = BetaUser.find(params[:id])

    respond_to do |format|
      if @beta_user.update_attributes(params[:beta_user])
        format.html { redirect_to admin_beta_user_path(@beta_user), notice: 'Beta user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @beta_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beta_users/1
  # DELETE /beta_users/1.json
  def destroy
    @beta_user = BetaUser.find(params[:id])
    @beta_user.destroy

    respond_to do |format|
      format.html { redirect_to admin_beta_users_url }
      format.json { head :no_content }
    end
  end
end
