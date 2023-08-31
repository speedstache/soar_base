require "application_system_test_case"

class AircraftUsersTest < ApplicationSystemTestCase
  setup do
    @aircraft_user = aircraft_users(:one)
  end

  test "visiting the index" do
    visit aircraft_users_url
    assert_selector "h1", text: "Aircraft users"
  end

  test "should create aircraft user" do
    visit aircraft_users_url
    click_on "New aircraft user"

    click_on "Create Aircraft user"

    assert_text "Aircraft user was successfully created"
    click_on "Back"
  end

  test "should update Aircraft user" do
    visit aircraft_user_url(@aircraft_user)
    click_on "Edit this aircraft user", match: :first

    click_on "Update Aircraft user"

    assert_text "Aircraft user was successfully updated"
    click_on "Back"
  end

  test "should destroy Aircraft user" do
    visit aircraft_user_url(@aircraft_user)
    click_on "Destroy this aircraft user", match: :first

    assert_text "Aircraft user was successfully destroyed"
  end
end
