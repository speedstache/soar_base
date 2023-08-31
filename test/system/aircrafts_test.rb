require "application_system_test_case"

class AircraftsTest < ApplicationSystemTestCase
  setup do
    @aircraft = aircrafts(:one)
  end

  test "visiting the index" do
    visit aircrafts_url
    assert_selector "h1", text: "Aircrafts"
  end

  test "should create aircraft" do
    visit aircrafts_url
    click_on "New aircraft"

    click_on "Create Aircraft"

    assert_text "Aircraft was successfully created"
    click_on "Back"
  end

  test "should update Aircraft" do
    visit aircraft_url(@aircraft)
    click_on "Edit this aircraft", match: :first

    click_on "Update Aircraft"

    assert_text "Aircraft was successfully updated"
    click_on "Back"
  end

  test "should destroy Aircraft" do
    visit aircraft_url(@aircraft)
    click_on "Destroy this aircraft", match: :first

    assert_text "Aircraft was successfully destroyed"
  end
end
