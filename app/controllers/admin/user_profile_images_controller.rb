class Admin::UserProfileImagesController < ApplicationController
  before_action :require_user
  before_action :require_user_admin
  before_action :set_user

  def update
    @user.profile_image = params.require(:profile_image)

    if @user.save
      redirect_to user_path(@user), notice: "Profile image updated."
    else
      redirect_to user_path(@user), alert: @user.errors.full_messages.to_sentence
    end
  end

  def destroy
    @user.remove_profile_image! if @user.profile_image_attached?
    redirect_to user_path(@user), notice: "Profile image removed."
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end