require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    #make admin user
    User.create!(name: 'Admin', password: 'password', is_super: true, is_admin: true, is_user: false, email: "ADMIN@ncsu.edu")

    #log in with admin to create/edit/show/delete accounts
    get user_session_path
    assert_equal 200, status
    post user_session_path, params: { user: { email: 'admin@ncsu.edu', password: 'password' } }
    follow_redirect!
    assert_equal 200, status
    @account = accounts(:one)
  end

  test "should get index" do
    get accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_account_url
    assert_response :success
  end

  test "should create account" do
    @account.id = 3
    @account.acc_number= 111111111

    #should show diff of count now that new account is created with new acc num and saved in DB
    assert_difference('Account.count') do
      post accounts_url, params: { account: { acc_number: @account.acc_number, user_id: @account.user_id, balance: @account.balance, is_closed: @account.is_closed } }
    end

    assert_redirected_to account_url(Account.last)
  end

  test "should show account" do
    get account_url(@account)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_url(@account)
    assert_response :success
  end

  test "should update account" do
    @account = accounts(:two)
    #this acct has no transactions, therefore should be able to be closed
    @account.is_closed= true
    patch account_url(@account), params: { account: { acc_number: @account.acc_number,user_id: @account.user_id, balance: @account.balance, is_closed: @account.is_closed } }
    assert_redirected_to account_url(@account)
  end

  test "should NOT update account" do
    #this account has a pending transaction, therefore should not be able to be closed!!!
    @account.is_closed= true
    patch account_url(@account), params: { account: { acc_number: @account.acc_number,user_id: @account.user_id, balance: @account.balance, is_closed: @account.is_closed } }
    assert_redirected_to accounts_url
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete account_url(@account)
    end

    assert_redirected_to accounts_url
  end
end
