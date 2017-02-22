require 'test_helper'

class AccountRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_request = account_requests(:one)
  end

  test "should get index" do
    get account_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_account_request_url
    assert_response :success
  end

  test "should create account_request" do
    assert_difference('AccountRequest.count') do
      post account_requests_url, params: { account_request: { created: @account_request.created, userid: @account_request.userid } }
    end

    assert_redirected_to account_request_url(AccountRequest.last)
  end

  test "should show account_request" do
    get account_request_url(@account_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_request_url(@account_request)
    assert_response :success
  end

  test "should update account_request" do
    patch account_request_url(@account_request), params: { account_request: { created: @account_request.created, userid: @account_request.userid } }
    assert_redirected_to account_request_url(@account_request)
  end

  test "should destroy account_request" do
    assert_difference('AccountRequest.count', -1) do
      delete account_request_url(@account_request)
    end

    assert_redirected_to account_requests_url
  end
end
