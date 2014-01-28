class Admin::CountriesController < AdminApplicationController
  
  # GET /admin/countries
  # GET /admin/countries.json
  def index
    @admin_countries = Country.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_countries }
    end
  end

  # GET /admin/countries/1
  # GET /admin/countries/1.json
  def show
    @admin_country = Country.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_country }
    end
  end

  # GET /admin/countries/new
  # GET /admin/countries/new.json
  def new
    @admin_country = Country.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_country }
    end
  end

  # GET /admin/countries/1/edit
  def edit
    @admin_country = Country.find(params[:id])
  end

  # POST /admin/countries
  # POST /admin/countries.json
  def create
    @admin_country = Country.new(params[:country])

    respond_to do |format|
      if @admin_country.save
        format.html { redirect_to admin_country_path(@admin_country), notice: 'Country was successfully created.' }
        format.json { render json: @admin_country, status: :created, location: @admin_country }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_country.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/countries/1
  # PUT /admin/countries/1.json
  def update
    @admin_country = Country.find(params[:id])

    respond_to do |format|
      if @admin_country.update_attributes(params[:country])
        format.html { redirect_to admin_country_path(@admin_country), notice: 'Country was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/countries/1
  # DELETE /admin/countries/1.json
  def destroy
    @admin_country = Country.find(params[:id])
    @admin_country.destroy

    respond_to do |format|
      format.html { redirect_to admin_countries_url }
      format.json { head :no_content }
    end
  end
end
