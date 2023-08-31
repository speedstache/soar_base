require "test_helper"

class MembershipUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @membership_user = membership_users(:one)
  end

  test "should get index" do
    get membership_users_url
    assert_response :success
  end

  test "should get new" do
    get new_membership_user_url
    assert_response :success
  end

  test "should create membership_user" do
    assert_difference("MembershipUser.count") do
      post membership_users_url, params: { membership_user: {  } }
    end

    assert_redirected_to membership_user_url(MembershipUser.last)
  end

  test "should show membership_user" do
    get membership_user_url(@membership_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_membership_user_url(@membership_user)
    assert_response :success
  end

  test "should update membership_user" do
    patch membership_user_url(@membership_user), params: { membership_user: {  } }
    assert_redirected_to membership_user_url(@membership_user)
  end

  test "should destroy membership_user" do
    assert_difference("MembershipUser.count", -1) do
      delete membership_user_url(@membership_user)
    end

    assert_redirected_to membership_users_url
  end
end
