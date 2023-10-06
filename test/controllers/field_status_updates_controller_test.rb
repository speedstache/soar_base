require "test_helper"

class FieldStatusUpdatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @field_status_update = field_status_updates(:one)
  end

  test "should get index" do
    get field_status_updates_url
    assert_response :success
  end

  test "should get new" do
    get new_field_status_update_url
    assert_response :success
  end

  test "should create field_status_update" do
    assert_difference("FieldStatusUpdate.count") do
      post field_status_updates_url, params: { field_status_update: {  } }
    end

    assert_redirected_to field_status_update_url(FieldStatusUpdate.last)
  end

  test "should show field_status_update" do
    get field_status_update_url(@field_status_update)
    assert_response :success
  end

  test "should get edit" do
    get edit_field_status_update_url(@field_status_update)
    assert_response :success
  end

  test "should update field_status_update" do
    patch field_status_update_url(@field_status_update), params: { field_status_update: {  } }
    assert_redirected_to field_status_update_url(@field_status_update)
  end

  test "should destroy field_status_update" do
    assert_difference("FieldStatusUpdate.count", -1) do
      delete field_status_update_url(@field_status_update)
    end

    assert_redirected_to field_status_updates_url
  end
end
