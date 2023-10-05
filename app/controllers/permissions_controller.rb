class PermissionsController < ApplicationController
  before_action :require_user
  before_action :set_permission, only: %i[ show edit update ]

  # GET /permissions or /permissions.json
  def index
    @permissions = Permission.all
  end

  # GET /permissions/1 or /permissions/1.json
  def show
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

    flash[:notice] = "New permissions set up"
    redirect_to users_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /permissions/1 or /permissions/1.json
  def update
    respond_to do |format|
      if @permission.update(permission_params)
        format.html { redirect_to permissions_path, notice: "Permission was successfully updated." }
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
      format.html { redirect_to permissions_url, notice: "Permission was successfully destroyed." }
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
      params.require(:permission).permit(:user_admin, :club_admin, :site_admin, :global_admin)
    end
end
