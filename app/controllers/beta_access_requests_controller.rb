class BetaAccessRequestsController < ApplicationController
  skip_authorize_resource :only => [:show, :new, :create]
  skip_before_filter :require_login

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

  # POST /beta_access_requests
  # POST /beta_access_requests.json
  def create
    @beta_access_request = BetaAccessRequest.new(params[:beta_access_request])

    respond_to do |format|
      if @beta_access_request.save
        NotificationMailer.delay.request_beta_access(@beta_access_request.email)
        format.html { redirect_to @beta_access_request, notice: 'Beta access request was successfully created.' }
        format.json { render json: @beta_access_request, status: :created, location: @beta_access_request }
      else
        format.html { render action: "new" }
        format.json { render json: @beta_access_request.errors, status: :unprocessable_entity }
      end
    end
  end
end
