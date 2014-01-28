class Admin::UsersController < AdminApplicationController
  def impersonate
    session[:impersonating] = true
    @user = User.find params[:id ]
    sign_out :user
    sign_in @user
    redirect_to root_path
  end

  # GET /admin/users
  # GET /admin/users.json
  def index
    if (params[:user] && params[:user][:email].size > 0)
      email = params[:user][:email]
      @admin_users = [User.find_by_email(params[:user][:email])].compact
    elsif (params[:user] && params[:user][:slug].size > 0)
      slug = params[:user][:slug]
      @admin_users = [User.find_by_slug(params[:user][:slug])].compact
    else
      @admin_users = User.page(params[:page])
    end
    @admin_user = User.new(slug: slug, email: email)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_users }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
    @admin_user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.json
  def new
    @admin_user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_user }
    end
  end

  # GET /admin/users/1/edit
  def edit
    @admin_user = User.find(params[:id])
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    @admin_user = User.new(params[:admin_user])

    respond_to do |format|
      if @admin_user.save
        format.html { redirect_to admin_user_path(@admin_user), notice: 'User was successfully created.' }
        format.json { render json: @admin_user, status: :created, location: @admin_user }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/users/1
  # PUT /admin/users/1.json
  def update
    @admin_user = User.find(params[:id])
    respond_to do |format|
      if @admin_user.update_attributes(params[:admin_user])
        format.html { redirect_to admin_user_path(@admin_user), notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    @admin_user = User.find(params[:id])
    @admin_user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_url }
      format.json { head :no_content }
    end
  end
end
