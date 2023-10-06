require "application_system_test_case"

class FieldStatusUpdatesTest < ApplicationSystemTestCase
  setup do
    @field_status_update = field_status_updates(:one)
  end

  test "visiting the index" do
    visit field_status_updates_url
    assert_selector "h1", text: "Field status updates"
  end

  test "should create field status update" do
    visit field_status_updates_url
    click_on "New field status update"

    click_on "Create Field status update"

    assert_text "Field status update was successfully created"
    click_on "Back"
  end

  test "should update Field status update" do
    visit field_status_update_url(@field_status_update)
    click_on "Edit this field status update", match: :first

    click_on "Update Field status update"

    assert_text "Field status update was successfully updated"
    click_on "Back"
  end

  test "should destroy Field status update" do
    visit field_status_update_url(@field_status_update)
    click_on "Destroy this field status update", match: :first

    assert_text "Field status update was successfully destroyed"
  end
end
