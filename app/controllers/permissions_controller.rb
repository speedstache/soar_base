class PermissionsController < ApplicationController
  before_action :require_user
  before_action :set_permission, only: %i[ edit update ]
  before_action :require_user_admin

  # GET /permissions or /permissions.json
  def index
    @permissions = Permission.all.includes(:user).order('users.username ASC').paginate(page: params[:page], per_page: 10)
    
  end

  # GET /permissions/new
  def new
    @permission = Permission.new
  end

  # GET /permissions/1/edit
  def edit
  end

  # POST /permissions or /permissions.json
  def create
    @permission = Permission.new(user_params)

    if @permission.save

    flash[:success] = "New permissions set up"
    redirect_to users_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /permissions/1 or /permissions/1.json
  def update
    respond_to do |format|
      if @permission.update(permission_params)
        flash[:success] = "Permission was successfully updated."
        format.html { redirect_to permissions_path }
        format.json { render :show, status: :ok, location: @permission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end 
  end

  # DELETE /permissions/1 or /permissions/1.json
  def destroy
    @permission.destroy

    respond_to do |format|
      flash[:success] = "Permission was successfully updated."
      format.html { redirect_to permissions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permission
      @permission = Permission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def permission_params
      params.require(:permission).permit(:instructor, :towpilot, :user_admin, :club_admin, :site_admin, :global_admin)
    end
end
