require "application_system_test_case"

class TowsTest < ApplicationSystemTestCase
  setup do
    @tow = tows(:one)
  end

  test "visiting the index" do
    visit tows_url
    assert_selector "h1", text: "Tows"
  end

  test "should create tow" do
    visit tows_url
    click_on "New tow"

    fill_in "Aircraft", with: @tow.aircraft_id
    fill_in "Fuel added", with: @tow.fuel_added
    fill_in "Oil added", with: @tow.oil_added
    fill_in "Releases", with: @tow.releases
    fill_in "Reservation", with: @tow.reservation_id
    fill_in "Tach end", with: @tow.tach_end
    fill_in "Tow date", with: @tow.tow_date
    fill_in "Tows", with: @tow.tows
    click_on "Create Tow"

    assert_text "Tow was successfully created"
    click_on "Back"
  end

  test "should update Tow" do
    visit tow_url(@tow)
    click_on "Edit this tow", match: :first

    fill_in "Aircraft", with: @tow.aircraft_id
    fill_in "Fuel added", with: @tow.fuel_added
    fill_in "Oil added", with: @tow.oil_added
    fill_in "Releases", with: @tow.releases
    fill_in "Reservation", with: @tow.reservation_id
    fill_in "Tach end", with: @tow.tach_end
    fill_in "Tow date", with: @tow.tow_date
    fill_in "Tows", with: @tow.tows
    click_on "Update Tow"

    assert_text "Tow was successfully updated"
    click_on "Back"
  end

  test "should destroy Tow" do
    visit tow_url(@tow)
    click_on "Destroy this tow", match: :first

    assert_text "Tow was successfully destroyed"
  end
end
