class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_user!, except: [:index, :show]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
    @view_pref = params[:id]
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @navigation = params[:id]
    @account = Account.new
    @req = User.find_by(:id => params[:userid])
    if !@req.nil?
      @account.user_id = @req.id
    end
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    respond_to do |format|
      @account = Account.new(account_params)
      @account.balance= 0
      @account.is_closed = false

      if !params[:req].nil?

        @request = AccountRequest.find_by_sql(["SELECT * from account_requests WHERE created = 'f' AND userid=?", params[:req]])

        @request[0].created=true
        @request[0].save
      end

      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update

    @open_transactions = Transaction.where(:account_id => @account, :status => 'Pending')
    if @open_transactions.present?
      redirect_to accounts_url, alert: 'Account has open transactions and cannot be closed.'
    else
      respond_to do |format|
        if @account.update(account_params)
          format.html { redirect_to @account, notice: 'Account status was successfully changed.' }
          format.json { render :show, status: :ok, location: @account }
        else
          format.html { render :edit }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account_transactions = Transaction.all
    @account_transactions.each do |transaction|
      if transaction.account.acc_number == @account.acc_number
        transaction.destroy
      elsif transaction.transtype == 'Borrow' && transaction.status == 'Pending' && transaction.receiver == @account.acc_number
        #a borrow trans, still pending, and has reciever as the acct being deleted, decline acct and set effective date
        transaction.status= 'Declined'
        transaction.effective_date = Time.now
        transaction.save
      end
    end
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:acc_number, :user_id, :is_closed, :balance)
    end
end
