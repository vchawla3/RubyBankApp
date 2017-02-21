class TransactionsController < ApplicationController
  #before_action :authenticate_user!
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
    current_user.current_account = params[:id]
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    current_user.current_account = @transaction.account.acc_number
    if @transaction.effective_date == nil && @transaction.status != 'Pending'
      @transaction.effective_date = Time.now
      @transaction.save
    end
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
    @current_account = User.find_by(:id => (current_user.id))
    @current_accounts = Account.where(:user_id => @current_account)

    current_user.current_account = params[:id] # used by "back" new.html.erb to return to calling account
    @link_transaction = Account.find_by_acc_number(params[:id])
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.start_date = Time.now

    if @transaction.amount > 1000 || @transaction.transtype == 'Deposit'
      @transaction.receiver = @transaction.account.acc_number
      @transaction.status = 'Pending'
    else
      @transaction.status = 'Approved'
      @transaction.effective_date = @transaction.start_date
    end

    if @transaction.transtype == 'Withdraw'
      @transaction.receiver = @transaction.account.acc_number
    end

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update

    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_path(:id=> @transaction.account.acc_number), notice: 'Transaction was successfully canceled.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:id, :transtype, :account_id, :receiver, :status, :amount, :start_date, :effective_date)
    end
end
