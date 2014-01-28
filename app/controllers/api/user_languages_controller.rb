class Api::UserLanguagesController <  Api::BaseController
  def index
  end

  def show
  end

  def update
  end

  def destroy
  end

  def new
  end

  def create
  end

  def mass_update
    user = current_user
    language_ids = params[:language_ids].split(',')
    @user_languages = UserLanguage.mass_update(language_ids, user)
    if (@user_languages)
      render "index"
    else
      errors = @user_languages.errors if @user_languages
      render json: {success:false, message: errors, status: :unprocessable_entity}
    end
  end
end
