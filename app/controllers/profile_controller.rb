class ProfileController < ApplicationController

def show
  @membership_info = current_user.memberships.last
  @my_membership = current_user.membership_users.last
end

def index
  @membership_info = current_user.memberships.last
  @my_membership = current_user.membership_users.last
  @my_renewal_date = @my_membership.renewal_date + @membership_info.renewal_period

end

def edit

end

def update
  @user = current_user

  respond_to do |format|
    if @user.update(user_params)
      format.html { redirect_to :action => profile_index_path, notice: "User profile was successfully updated." }
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

end