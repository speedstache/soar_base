class MembershipUsersController < ApplicationController
  before_action :set_membership_user, only: %i[ show edit update destroy ]

  # GET /membership_users or /membership_users.json
  def index
    @membership_users = MembershipUser.all
  end

  # GET /membership_users/1 or /membership_users/1.json
  def show
  end

  # GET /membership_users/new
  def new
    @membership_user = MembershipUser.new
  end

  # GET /membership_users/1/edit
  def edit
  end

  # POST /membership_users or /membership_users.json
  def create
    @membership_user = MembershipUser.new(membership_user_params)

    
    if @membership_user.save
      flash[:notice] = "Membership and User link was successfully created."
      redirect_to membership_users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /membership_users/1 or /membership_users/1.json
  def update
    respond_to do |format|
      if @membership_user.update(membership_user_params)
        format.html { redirect_to membership_users_path, notice: "Membership user was successfully updated." }
        format.json { render :show, status: :ok, location: @membership_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /membership_users/1 or /membership_users/1.json
  def destroy
    @membership_user.destroy

    respond_to do |format|
      format.html { redirect_to membership_users_url, notice: "Membership user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership_user
      @membership_user = MembershipUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def membership_user_params
      params.require(:membership_user).permit(:user_id, :membership_id, :renewal_date, :active_flag)
    end
end
