require "test_helper"

class ProfileControllerTest < ActionController::TestCase
  test "profile edit includes the image editor and no Gravatar instructions" do
    user = users(:michael)
    user.create_permission
    session[:user_id] = user.id

    get :edit, params: { id: user.id }

    assert_response :success
    assert_select "input[type=file][accept='image/jpeg,image/png,image/webp']"
    assert_no_match(/gravatar/i, response.body)
  end
end