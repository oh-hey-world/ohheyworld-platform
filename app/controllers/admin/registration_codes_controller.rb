class Admin::RegistrationCodesController < AdminApplicationController
  # GET /admin/registration_codes
  # GET /admin/registration_codes.json
  def index
    @registration_codes = RegistrationCode.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @registration_codes }
    end
  end

  # GET /admin/registration_codes/1
  # GET /admin/registration_codes/1.json
  def show
    @registration_code = RegistrationCode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @registration_code }
    end
  end

  # GET /admin/registration_codes/new
  # GET /admin/registration_codes/new.json
  def new
    @registration_code = RegistrationCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @registration_code }
    end
  end

  # GET /admin/registration_codes/1/edit
  def edit
    @registration_code = RegistrationCode.find(params[:id])
  end

  # POST /admin/registration_codes
  # POST /admin/registration_codes.json
  def create
    @registration_code = RegistrationCode.new(params[:registration_code])

    respond_to do |format|
      if @registration_code.save
        format.html { redirect_to [:admin, @registration_code], notice: 'Registration code was successfully created.' }
        format.json { render json: @registration_code, status: :created, location: @registration_code }
      else
        format.html { render action: "new" }
        format.json { render json: @registration_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/registration_codes/1
  # PUT /admin/registration_codes/1.json
  def update
    @registration_code = RegistrationCode.find(params[:id])

    respond_to do |format|
      if @registration_code.update_attributes(params[:registration_code])
        format.html { redirect_to [:admin, @registration_code], notice: 'Registration code was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @registration_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/registration_codes/1
  # DELETE /admin/registration_codes/1.json
  def destroy
    @registration_code = RegistrationCode.find(params[:id])
    @registration_code.destroy

    respond_to do |format|
      format.html { redirect_to admin_registration_codes_url }
      format.json { head :no_content }
    end
  end

end
