class MembershipUsersController < ApplicationController
  before_action :require_user
  before_action :set_membership_user, only: %i[ show edit update destroy ]
  before_action :require_user_admin

  # GET /membership_users or /membership_users.json
  def index
    @membership_users = MembershipUser.all.includes(:user).order('users.username ASC').paginate(page: params[:page], per_page: 10)
    @active_users = User.where.not(status: 'archive')
    @unassigned_users = @active_users.where.not(id: MembershipUser.all.pluck(:user_id))

    @unassigned_user_id = params[:id]
    @memberships = Membership.where(active_flag: true)

  end

  # GET /membership_users/1 or /membership_users/1.json
  def show
  end

  # GET /membership_users/new
  def new
    @membership_user = MembershipUser.new

    @unassigned_user_id = params[:id]

  end

  # GET /membership_users/1/edit
  def edit
  end

  # POST /membership_users or /membership_users.json
  def create
    @membership_user = MembershipUser.new(membership_user_params)

    
    if @membership_user.save
      flash[:success] = "Membership and User link was successfully created."
      redirect_to membership_users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /membership_users/1 or /membership_users/1.json
  def update

    @renew = params[:status]

    respond_to do |format|
      if @membership_user.update(membership_user_params)
        flash[:success] = "Membership user was successfully updated."
        format.html { redirect_to membership_users_path }
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
      flash[:warning] = "Membership user was successfully deleted."
      format.html { redirect_to membership_users_url}
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
      params.require(:membership_user).permit(:user_id, :membership_id, :joined_date, :renewal_date, :active_flag)
    end
end
