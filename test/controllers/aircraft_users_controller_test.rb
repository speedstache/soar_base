require "test_helper"

class AircraftUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @aircraft_user = aircraft_users(:one)
  end

  test "should get index" do
    get aircraft_users_url
    assert_response :success
  end

  test "should get new" do
    get new_aircraft_user_url
    assert_response :success
  end

  test "should create aircraft_user" do
    assert_difference("AircraftUser.count") do
      post aircraft_users_url, params: { aircraft_user: {  } }
    end

    assert_redirected_to aircraft_user_url(AircraftUser.last)
  end

  test "should show aircraft_user" do
    get aircraft_user_url(@aircraft_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_aircraft_user_url(@aircraft_user)
    assert_response :success
  end

  test "should update aircraft_user" do
    patch aircraft_user_url(@aircraft_user), params: { aircraft_user: {  } }
    assert_redirected_to aircraft_user_url(@aircraft_user)
  end

  test "should destroy aircraft_user" do
    assert_difference("AircraftUser.count", -1) do
      delete aircraft_user_url(@aircraft_user)
    end

    assert_redirected_to aircraft_users_url
  end
end
