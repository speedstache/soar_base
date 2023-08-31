require "application_system_test_case"

class MembershipUsersTest < ApplicationSystemTestCase
  setup do
    @membership_user = membership_users(:one)
  end

  test "visiting the index" do
    visit membership_users_url
    assert_selector "h1", text: "Membership users"
  end

  test "should create membership user" do
    visit membership_users_url
    click_on "New membership user"

    click_on "Create Membership user"

    assert_text "Membership user was successfully created"
    click_on "Back"
  end

  test "should update Membership user" do
    visit membership_user_url(@membership_user)
    click_on "Edit this membership user", match: :first

    click_on "Update Membership user"

    assert_text "Membership user was successfully updated"
    click_on "Back"
  end

  test "should destroy Membership user" do
    visit membership_user_url(@membership_user)
    click_on "Destroy this membership user", match: :first

    assert_text "Membership user was successfully destroyed"
  end
end
