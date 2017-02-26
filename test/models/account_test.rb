require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # Account model being tested here
  # Constraints are..
  # acct num must be 9 digits and
  # balance cannot be less than 0 and
  # userid must be present

  def setup
    @account = Account.new
    @account.is_closed = false
    @account.acc_number = 333333333
  end

  test "user id must be present" do
    assert_not @account.save
  end

  test "account cannot have a balance less than zero" do
    @account.user_id = 1
    @account.balance = -100
    assert_not @account.save
  end

  test "account can have a balance more than zero" do
    @account.user_id = 1
    @account.balance = 100
    assert @account.save
  end

  test "acct num has to be 9 digits" do
    @account.user_id = 1

    #more than 9 digits, fail
    @account.acc_number = 3333333333
    assert_not @account.save

    #less than 9 digits, fail
    @account.acc_number = 33333333
    assert_not @account.save
  end

  test "acct num is 9 digits" do
    @account.user_id = 1
    assert @account.save
  end


end
