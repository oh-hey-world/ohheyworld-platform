class Admin::LanguagesController < AdminApplicationController
  
  # GET /admin/languages
  # GET /admin/languages.json
  def index
    @languages = Language.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_languages }
    end
  end

  # GET /admin/languages/1
  # GET /admin/languages/1.json
  def show
    @language = Language.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @language }
    end
  end

  # GET /admin/languages/new
  # GET /admin/languages/new.json
  def new
    @language = Language.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @language }
    end
  end

  # GET /admin/languages/1/edit
  def edit
    @language = Language.find(params[:id])
  end

  # POST /admin/languages
  # POST /admin/languages.json
  def create
    @language = Language.new(params[:language])

    respond_to do |format|
      if @language.save
        format.html { redirect_to admin_language_path(@language), notice: 'Language was successfully created.' }
        format.json { render json: @language, status: :created, location: @language }
      else
        format.html { render action: "new" }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/languages/1
  # PUT /admin/languages/1.json
  def update
    @language = Language.find(params[:id])

    respond_to do |format|
      if @language.update_attributes(params[:language])
        format.html { redirect_to admin_language_path(@language), notice: 'Language was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/languages/1
  # DELETE /admin/languages/1.json
  def destroy
    @language = Language.find(params[:id])
    @language.destroy

    respond_to do |format|
      format.html { redirect_to admin_languages_url }
      format.json { head :no_content }
    end
  end
end
