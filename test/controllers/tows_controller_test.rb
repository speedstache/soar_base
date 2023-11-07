require "test_helper"

class TowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tow = tows(:one)
  end

  test "should get index" do
    get tows_url
    assert_response :success
  end

  test "should get new" do
    get new_tow_url
    assert_response :success
  end

  test "should create tow" do
    assert_difference("Tow.count") do
      post tows_url, params: { tow: { aircraft_id: @tow.aircraft_id, fuel_added: @tow.fuel_added, oil_added: @tow.oil_added, releases: @tow.releases, reservation_id: @tow.reservation_id, tach_end: @tow.tach_end, tow_date: @tow.tow_date, tows: @tow.tows } }
    end

    assert_redirected_to tow_url(Tow.last)
  end

  test "should show tow" do
    get tow_url(@tow)
    assert_response :success
  end

  test "should get edit" do
    get edit_tow_url(@tow)
    assert_response :success
  end

  test "should update tow" do
    patch tow_url(@tow), params: { tow: { aircraft_id: @tow.aircraft_id, fuel_added: @tow.fuel_added, oil_added: @tow.oil_added, releases: @tow.releases, reservation_id: @tow.reservation_id, tach_end: @tow.tach_end, tow_date: @tow.tow_date, tows: @tow.tows } }
    assert_redirected_to tow_url(@tow)
  end

  test "should destroy tow" do
    assert_difference("Tow.count", -1) do
      delete tow_url(@tow)
    end

    assert_redirected_to tows_url
  end
end
