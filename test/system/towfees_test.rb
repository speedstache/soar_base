require "application_system_test_case"

class TowfeesTest < ApplicationSystemTestCase
  setup do
    @towfee = towfees(:one)
  end

  test "visiting the index" do
    visit towfees_url
    assert_selector "h1", text: "Towfees"
  end

  test "should create towfee" do
    visit towfees_url
    click_on "New towfee"

    click_on "Create Towfee"

    assert_text "Towfee was successfully created"
    click_on "Back"
  end

  test "should update Towfee" do
    visit towfee_url(@towfee)
    click_on "Edit this towfee", match: :first

    click_on "Update Towfee"

    assert_text "Towfee was successfully updated"
    click_on "Back"
  end

  test "should destroy Towfee" do
    visit towfee_url(@towfee)
    click_on "Destroy this towfee", match: :first

    assert_text "Towfee was successfully destroyed"
  end
end
