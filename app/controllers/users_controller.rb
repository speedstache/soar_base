class UsersController < ApplicationController
  before_action :require_user
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_user_admin, only: %i[ create destroy ]
  before_action :require_same_user, only: %i[edit update]

  # GET /users or /users.json
  def index
    @users = User.where.not(status: 'archive').paginate(page: params[:page], per_page: 10).order(:username)
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
    @membership_info = @user.memberships.last
    @my_membership = @user.membership_users.last
    @my_renewal_date = @my_membership.renewal_date + @membership_info.renewal_period
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end


  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    if @user.save

      # create blank permission record, defaults set to false
      @permission = @user.create_permission
      @profile = @user.create_profile

      if params[:user][:activate_now] == "1"
        UserMailer.account_activation(@user).deliver_now
        flash[:info] = "Account Activation! Please advise user to check email to activate account."
      else
        flash[:info] = "User saved. Remember to send activation link later"
      end  

    redirect_to users_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def resend

    @user = User.find_by(id: params[:sendme])

    @user.refresh_activation_digest
    UserMailer.resend_activation(@user).deliver_now
    flash[:info] = "Account Activation resent! Advise user to check email to activate account."
    redirect_to users_path

  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)

        flash[:success] = "Profile info successfully updated."
        format.html { redirect_to params[:previous_request] }
        format.json { render :show, status: :ok, location: @user }
      else

        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def archived_index
    @archived_users = User.where(status: 'archive')
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :email, :password,
                                   :password_confirmation, :previous_request, :activate_now, :status, profile_attributes: [:phone_number, :date_of_birth, :street_first_line, :street_second_line, :city, :state, :zip, :emergency_contact, :emergency_phone])
    end

    def require_same_user
      @user = User.find(params[:id])
    
      if current_user.id != @user.id && !current_user.permission.club_admin? && !current_user.permission.instructor?
      flash[:alert] = "You can only view or edit your own profile"
      redirect_to profile_index_path
      end
    end

end
