class ProfileImagesController < ApplicationController
  before_action :require_user

  def show
    user = User.find(params[:user_id])
    return head :not_found unless user.profile_image_attached?

    image = user.profile_image_record
    response.headers["Cache-Control"] = "no-store"
    send_data image.image_data, type: image.content_type, disposition: "inline", filename: "profile-image"
  end

  def create
    current_user.profile_image = params.require(:profile_image)

    if current_user.save
      redirect_to profile_path(current_user), notice: "Profile image updated."
    else
      redirect_to edit_profile_path(current_user), alert: current_user.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.remove_profile_image! if current_user.profile_image_attached?
    redirect_to profile_path(current_user), notice: "Profile image removed."
  end
end