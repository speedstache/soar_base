require "test_helper"

class Admin::UserProfileImagesControllerTest < ActionController::TestCase
  setup do
    @admin = users(:michael)
    @admin.create_permission(user_admin: true)
    @user = users(:archer)
    @user.create_permission
  end

  test "user admin can replace a user's profile image" do
    session[:user_id] = @admin.id

    patch :update, params: { user_id: @user.id, profile_image: uploaded_image }

    assert_redirected_to user_path(@user)
    assert @user.reload.profile_image_attached?
  end

  test "user admin can remove a user's profile image" do
    @user.profile_image = uploaded_image
    @user.save!
    session[:user_id] = @admin.id

    delete :destroy, params: { user_id: @user.id }

    assert_redirected_to user_path(@user)
    assert_not @user.reload.profile_image_attached?
  end

  test "non-admin cannot replace a user's profile image" do
    session[:user_id] = @user.id

    patch :update, params: { user_id: @user.id, profile_image: uploaded_image }

    assert_redirected_to reservations_url
    assert_not @user.reload.profile_image_attached?
  end

  test "anonymous user cannot remove a profile image" do
    @user.profile_image = uploaded_image
    @user.save!

    delete :destroy, params: { user_id: @user.id }

    assert_redirected_to login_path
    assert @user.reload.profile_image_attached?
  end

  private

  def uploaded_image
    tempfile = Tempfile.new(["profile", ".png"])
    tempfile.binmode
    tempfile.write("\x89PNG\r\n\x1A\n".b.ljust(16, "x"))
    tempfile.rewind
    Rack::Test::UploadedFile.new(tempfile.path, "image/png", original_filename: "profile.png")
  end
end