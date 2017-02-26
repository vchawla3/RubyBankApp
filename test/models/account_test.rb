require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # Account model being tested here
  # Constraints are..
  # acct num must be 9 digits and
  # balance cannot be less than 0 and
  # userid must be present

  def setup
    @account = Account.new
    @account.acc_number = 123456789
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
    @account.acc_number = 1234567891
    assert_not @account.save
    @account.acc_number = 12345678
    assert_not @account.save
  end

  test "acct num is 9 digits" do
    @account.user_id = 1
    assert @account.save
  end


end
