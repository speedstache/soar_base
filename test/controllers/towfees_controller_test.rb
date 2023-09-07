require "test_helper"

class TowfeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @towfee = towfees(:one)
  end

  test "should get index" do
    get towfees_url
    assert_response :success
  end

  test "should get new" do
    get new_towfee_url
    assert_response :success
  end

  test "should create towfee" do
    assert_difference("Towfee.count") do
      post towfees_url, params: { towfee: {  } }
    end

    assert_redirected_to towfee_url(Towfee.last)
  end

  test "should show towfee" do
    get towfee_url(@towfee)
    assert_response :success
  end

  test "should get edit" do
    get edit_towfee_url(@towfee)
    assert_response :success
  end

  test "should update towfee" do
    patch towfee_url(@towfee), params: { towfee: {  } }
    assert_redirected_to towfee_url(@towfee)
  end

  test "should destroy towfee" do
    assert_difference("Towfee.count", -1) do
      delete towfee_url(@towfee)
    end

    assert_redirected_to towfees_url
  end
end
