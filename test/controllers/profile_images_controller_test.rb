require "test_helper"

class ProfileImagesControllerTest < ActionController::TestCase
  setup do
    @user = users(:michael)
    @user.create_permission unless @user.permission
    session[:user_id] = @user.id
  end

  test "signed in user can upload a valid profile image" do
    post :create, params: { profile_image: uploaded_image("image/png", "profile.png") }

    assert_redirected_to profile_path(@user)
    assert @user.reload.profile_image_attached?
  end

  test "upload rejects unsupported content types" do
    post :create, params: { profile_image: uploaded_image("image/svg+xml", "profile.svg") }

    assert_redirected_to edit_profile_path(@user)
    assert_not @user.reload.profile_image_attached?
  end

  test "anonymous user cannot upload a profile image" do
    session[:user_id] = nil

    post :create, params: { profile_image: uploaded_image("image/png", "profile.png") }

    assert_redirected_to login_path
  end

  test "image endpoint serves stored image bytes" do
    @user.profile_image = uploaded_image("image/png", "profile.png")
    @user.save!

    get :show, params: { user_id: @user.id }

    assert_response :success
    assert_equal "image/png", response.media_type
    assert_equal @user.profile_image_record.image_data, response.body
    assert_equal "no-store", response.headers["Cache-Control"]
  end

  private

  def uploaded_image(content_type, filename, size: 16)
    tempfile = Tempfile.new(["profile", File.extname(filename)])
    tempfile.binmode
    signature = case content_type
    when "image/png" then "\x89PNG\r\n\x1A\n".b
    when "image/jpeg" then "\xFF\xD8\xFF".b
    when "image/webp" then "RIFF\x00\x00\x00\x00WEBP".b
    else "<svg>".b
    end
    tempfile.write(signature.ljust(size, "x"))
    tempfile.rewind
    Rack::Test::UploadedFile.new(tempfile.path, content_type, original_filename: filename)
  end
end