class AccountRequestsController < ApplicationController
  before_action :set_account_request, only: [:show, :edit, :update, :destroy]

  # GET /account_requests
  # GET /account_requests.json
  def index
    @account_requests = AccountRequest.all
  end

  # GET /account_requests/1
  # GET /account_requests/1.json
  def show
  end

  # GET /account_requests/new
  def new
    @account_request = AccountRequest.new
    @numRequests = AccountRequest.count_by_sql "SELECT COUNT(*) FROM account_requests a WHERE a.userid = #{current_user.id} AND a.created = 'f'"
  end

  # GET /account_requests/1/edit
  def edit
  end

  # POST /account_requests
  # POST /account_requests.json
  def create
    @account_request = AccountRequest.new
    @account_request.userid= current_user.id
    respond_to do |format|
      if @account_request.save
        format.html { redirect_to @account_request, notice: 'Account request was successfully created.' }
        format.json { render :show, status: :created, location: @account_request }
      else
        format.html { render :new }
        format.json { render json: @account_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_requests/1
  # PATCH/PUT /account_requests/1.json
  def update
    respond_to do |format|
      if @account_request.update(account_request_params)
        format.html { redirect_to @account_request, notice: 'Account request was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_request }
      else
        format.html { render :edit }
        format.json { render json: @account_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_requests/1
  # DELETE /account_requests/1.json
  def destroy
    @account_request.destroy
    respond_to do |format|
      format.html { redirect_to account_requests_url, notice: 'Account request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_request
      @account_request = AccountRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_request_params
      params.require(:account_request).permit(:userid, :created)
    end
end
