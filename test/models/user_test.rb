require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "profile image accepts JPEG PNG and WebP" do
    {
      "image/jpeg" => "\xFF\xD8\xFF".b,
      "image/png" => "\x89PNG\r\n\x1A\n".b,
      "image/webp" => "RIFF\x00\x00\x00\x00WEBP".b
    }.each do |content_type, signature|
      user = users(:michael)
      user.profile_image = uploaded_image(content_type, signature)

      assert user.valid?, "expected #{content_type} to be valid"
    end
  end

  test "profile image rejects unsupported types and files over 5 MiB" do
    user = users(:michael)
    user.profile_image = uploaded_image("image/svg+xml", "<svg>".b)
    assert_not user.valid?

    user.profile_image = uploaded_image("image/png", "\x89PNG\r\n\x1A\n".b, size: 5.megabytes + 1)
    assert_not user.valid?
  end

  private

  def uploaded_image(content_type, signature, size: 16)
    tempfile = Tempfile.new(["profile", ".img"])
    tempfile.binmode
    tempfile.write(signature.ljust(size, "x"))
    tempfile.rewind
    Rack::Test::UploadedFile.new(tempfile.path, content_type, original_filename: "profile.img")
  end
end
