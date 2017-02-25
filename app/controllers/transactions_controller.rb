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
    @current_accounts = Account.where(:user_id => @current_account, :is_closed => 'f')
    current_user.current_transaction = params[:event]
    @my_selection = params[:id]

    results1 = ActiveRecord::Base.connection.execute("SELECT * FROM accounts WHERE user_id='#{current_user.id}' AND is_closed='f'")
    accounts = results1.collect{ |x| x['acc_number'] }

    if @current_accounts.present?
      puts "\n\n\nResults:"
      puts @current_accounts.all
      puts @current_accounts.all.collect{ |c| [ c.acc_number, c.id ]}
      puts @current_accounts.all[0].id.is_a? Integer
      puts results1
      puts accounts
      puts results1.collect{ |c| [ c["acc_number"], c["id"]]}
      puts "\n\n\n"
    end
    #results2 = ActiveRecord::Base.connection.execute("SELECT acc_number FROM accounts WHERE (user_id=\'#{current_user.id}\' AND is_closed='f') OR (user_id IN (SELECT friend1 FROM friends WHERE friend2='#{current_user.id}') AND is_closed='f') OR (user_id IN (SELECT friend2 FROM friends WHERE friend1='#{current_user.id}') AND is_closed='f'))")
    results2 = ActiveRecord::Base.connection.execute("SELECT * FROM accounts WHERE (user_id='#{current_user.id}' AND is_closed='f') OR (user_id IN (SELECT friend2 FROM friends WHERE friend1='#{current_user.id}') AND is_closed='f') OR (user_id IN (SELECT friend1 FROM friends WHERE friend2='#{current_user.id}') AND is_closed='f')")
    names = results2.collect{ |x| ActiveRecord::Base.connection.execute("SELECT name FROM users WHERE id='#{x['user_id']}'") }
    puts results2
    puts names
    #names.zip(results2).each{ |name, result|
    #  puts name[0]['name']
    #  puts result['acc_number']
    #}

    accounts2 = names.zip(results2).collect{ |name, result| "#{name[0]['name'].to_s}-#{result['acc_number'].to_s}" }
    puts accounts2
    puts "\n\n\n"

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
      puts transaction_params[:account_id]
      acc_number_arr = ActiveRecord::Base.connection.execute("SELECT acc_number FROM accounts WHERE id='#{transaction_params[:account_id]}'")

      @transaction.receiver = acc_number_arr[0][0]    #= @transaction.account.acc_number
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
      puts "TRANSACTION STATUS:"
      puts transaction_params[:account_id]
      puts transaction_params[:receiver]
      puts transaction_params[:transtype]
      acc_number_arr = ActiveRecord::Base.connection.execute("SELECT acc_number FROM accounts WHERE id='#{transaction_params[:account_id]}'")
      @transaction.status = 'Approved'
      @transaction.effective_date = @transaction.start_date


      @account = Account.find_by_acc_number(acc_number_arr[0][0])
      bal = @account.balance

      if transaction_params[:transtype] == 'Send'
        #receiving account
        @accountRec = Account.find_by_acc_number(transaction_params[:receiver])
        balRec = @accountRec.balance

        #take money from sender
        bal-= @transaction.amount
        @account.balance= bal

        #give money to rec
        balRec+= @transaction.amount
        @accountRec.balance= balRec

        respond_to do |format|
          if @account.save
            #first account had enough money, now just update second account. NO if needed cuz adding money should always work
            @accountRec.save
            if @transaction.save
              format.html { redirect_to @transaction, notice: 'Transaction was successfully created and Account updated.' }
              format.json { render :show, status: :created, location: @transaction }
            else
              format.html { render :new }
              format.json { render json: @transaction.errors, status: :unprocessable_entity }
            end
          else
            #if the first account cannot be saved AKA it doesn't have the money, then this error will throw and show up
            format.json { render json: @account.errors, status: :unprocessable_entity }
            format.html { redirect_to @account, alert: @account.errors.full_messages[0].to_s }
          end
        end
      elsif transaction_params[:transtype] == 'Borrow'
        puts
        #handle differently
        @transaction.status = 'Pending'

        respond_to do |format|
          if @account.save
            if @transaction.save
              format.html { redirect_to @transaction, notice: 'Borrow request has been sent.' }
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

      else
        #not a send or borrow, just deal with 1 account then
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
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    @transaction2 = Transaction.new(transaction_params)
    @transaction.status=@transaction2.status

    @transaction.effective_date = Time.now
    @account = nil
    bal = 0
    if @transaction.status == 'Approved' && (@transaction.transtype == 'Deposit' || @transaction.transtype == 'Withdraw')
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
    elsif @transaction.status == 'Approved' && @transaction.transtype == 'Borrow'
      @account = Account.find_by_acc_number(@transaction.receiver)
      bal = @account.balance
      acc_number_arr = ActiveRecord::Base.connection.execute("SELECT acc_number FROM accounts WHERE id='#{@transaction.account_id}'")

      #receiving account
      @accountRec = Account.find_by_acc_number(acc_number_arr[0][0])
      balRec = @accountRec.balance

      #give money to receiver
      bal+= @transaction.amount
      @account.balance= bal

      #take money from sender
      balRec-= @transaction.amount
      @accountRec.balance= balRec

      respond_to do |format|
        if @account.save
          #first account had enough money, now just update second account. NO if needed cuz adding money should always work
          @accountRec.save
          if @transaction.save
            format.html { redirect_to @transaction, notice: 'Transaction was successfully created and Account updated.' }
            format.json { render :show, status: :created, location: @transaction }
          else
            format.html { render :new }
            format.json { render json: @transaction.errors, status: :unprocessable_entity }
          end
        else
          #if the first account cannot be saved AKA it doesn't have the money, then this error will throw and show up
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

    if @transaction.status == 'Pending' && current_user.is_admin
      redirect_to transactions_path(:id => '1')
    elsif @transaction.status == 'Pending'
      redirect_to transactions_path()
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
