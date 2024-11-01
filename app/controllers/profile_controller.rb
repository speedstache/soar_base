class ProfileController < ApplicationController
  before_action :require_user
  before_action :require_same_user, only: [:show, :edit, :update, :destroy]

def show
  @user = User.find(params[:id])

  #If @user doesn't have a membership, return any value. The show template doesn't display this data anyway
  if @user.membership_users.blank?
    @membership_info = MembershipUser.find(3)
    @membership = Membership.find_by(id: @membership_info.membership_id)
    @renewal_date = @membership_info.renewal_date + @membership.renewal_period
  else
    @membership_info = MembershipUser.find_by(user_id: @user.id)
    @membership = Membership.find_by(id: @membership_info.membership_id)
    @renewal_date = @membership_info.renewal_date + @membership.renewal_period
  end

end

def index

  @users = User.where.not(status: 'archive').paginate(page: params[:page], per_page: 10).order(:username)

end

def edit
 
end

def update
  @user = User.find(params[:id])

  respond_to do |format|
    if @user.update(user_params)
      flash[:success] = "User profile was successfully updated."
      format.html { redirect_to :action => profile_index_path }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

end

private

# Only allow a list of trusted parameters through.
def user_params
  params.require(current_user).permit(:username, :email)
end

def require_same_user
  @user = User.find(params[:id])

  if current_user.id != @user.id && !current_user.permission.club_admin? && !current_user.permission.instructor?
  flash[:alert] = "You can only view or edit your own profile"
  redirect_to profile_index_path
  end
end


end