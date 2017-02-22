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

    if (@transaction.amount > 1000 && @transaction.transtype == 'Withdraw') || @transaction.transtype == 'Deposit'
      @transaction.receiver = @transaction.account.acc_number
      @transaction.status = 'Pending'


      # only save the transaction b/c pending, no account balance edited
      respond_to do |format|
        if @transaction.save
            format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
            format.json { render :show, status: :created, location: @transaction }
        else
          format.html { render :new }
          format.json { render json: @transaction.errors, status: :unprocessable_entity }
        end
      end
    else
      @transaction.status = 'Approved'
      @transaction.effective_date = @transaction.start_date

      @account = Account.find_by_acc_number(@transaction.account.acc_number)
      bal = @account.balance

      if @transaction.transtype == 'Withdraw'
        bal-= @transaction.amount
      end

      if @transaction.transtype == 'Deposit'
        bal+= @transaction.amount
      end
      @account.balance= bal

      # save the account, make sure it no error (balance < 0), then save the transaction!
      respond_to do |format|
        if @account.save
          if @transaction.save
            format.html { redirect_to @transaction, notice: 'Transaction was successfully created and Account updated.' }
            format.json { render :show, status: :created, location: @transaction }
          else
            format.html { render :new }
            format.json { render json: @transaction.errors, status: :unprocessable_entity }
          end
        else
          #format.html { render :new }
          #format.json { render json: @friend.errors, status: :unprocessable_entity }

          #not sure if we want this, will take to specific account page with error at top
          format.json { render json: @account.errors, status: :unprocessable_entity }
          format.html { redirect_to @account, alert: @account.errors.full_messages[0].to_s }
        end
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    @transaction2 = Transaction.new(transaction_params)
    @transaction.status=@transaction2.status

    @transaction.effective_date = Time.now
    @account = nil
    bal = 0
    if @transaction.status == 'Approved'
      #update account info
      @account = Account.find_by_acc_number(@transaction.receiver)
      bal = @account.balance
      if @transaction.transtype == 'Deposit'
        #put money into receiving acct
        bal+= @transaction.amount

      elsif @transaction.transtype == 'Withdraw'
        #take money from receiving acct
        bal-= @transaction.amount
      end
      @account.balance=bal

      #right now, if account doesn't save, neither will transaction and it will redirect to account page with alert
      respond_to do |format|
        if @account.save
          if @transaction.update(transaction_params)
            format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
            format.json { render :show, status: :ok, location: @transaction }
          else
            format.html { render :edit }
            format.json { render json: @transaction.errors, status: :unprocessable_entity }
          end
        else
          #not sure if we want this, will take to spefic account page with error at top
          format.json { render json: @account.errors, status: :unprocessable_entity }
          format.html { redirect_to @account, alert: @account.errors.full_messages[0].to_s }
        end
      end
    end
    if @transaction.status == 'Declined'
      #do nothing?
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

    if @transaction.status == 'Pending'
        redirect_to transactions_path(:id => '1')
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
