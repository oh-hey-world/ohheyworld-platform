class Admin::BetaAccessRequestsController < AdminApplicationController
  # GET /beta_access_requests
  # GET /beta_access_requests.json
  def index
    @beta_access_requests = BetaAccessRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @beta_access_requests }
    end
  end

  # GET /beta_access_requests/1
  # GET /beta_access_requests/1.json
  def show
    @beta_access_request = BetaAccessRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @beta_access_request }
    end
  end

  # GET /beta_access_requests/new
  # GET /beta_access_requests/new.json
  def new
    @beta_access_request = BetaAccessRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @beta_access_request }
    end
  end

  # GET /beta_access_requests/1/edit
  def edit
    @beta_access_request = BetaAccessRequest.find(params[:id])
  end

  # POST /beta_access_requests
  # POST /beta_access_requests.json
  def create
    @beta_access_request = BetaAccessRequest.new(params[:beta_access_request])

    respond_to do |format|
      if @beta_access_request.save
        format.html { redirect_to admin_beta_access_request_path(@beta_access_request), notice: 'Beta access request was successfully created.' }
        format.json { render json: @beta_access_request, status: :created, location: @beta_access_request }
      else
        format.html { render action: "new" }
        format.json { render json: @beta_access_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /beta_access_requests/1
  # PUT /beta_access_requests/1.json
  def update
    @beta_access_request = BetaAccessRequest.find(params[:id])

    respond_to do |format|
      if @beta_access_request.update_attributes(params[:beta_access_request])
        format.html { redirect_to admin_beta_access_request_path(@beta_access_request), notice: 'Beta access request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @beta_access_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beta_access_requests/1
  # DELETE /beta_access_requests/1.json
  def destroy
    @beta_access_request = BetaAccessRequest.find(params[:id])
    @beta_access_request.destroy

    respond_to do |format|
      format.html { redirect_to admin_beta_access_requests_url }
      format.json { head :no_content }
    end
  end
end
