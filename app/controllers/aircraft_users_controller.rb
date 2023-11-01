class AircraftUsersController < ApplicationController
  before_action :require_user
  before_action :set_aircraft_user, only: %i[ show edit update destroy ]
  before_action :require_user_admin

  # GET /aircraft_users or /aircraft_users.json
  def index

    @id = params[:id]

    @aircraft_users = AircraftUser.all
    @aircrafts = Aircraft.where(group: "club")
    @users = User.all

    @assigned_users = User.where(id: AircraftUser.all.pluck(:user_id))

    @unassigned_users = User.where.not(id: AircraftUser.all.pluck(:user_id))
  end

  # GET /aircraft_users/1 or /aircraft_users/1.json
  def show
  end

  # GET /aircraft_users/new
  def new
    @aircraft_user = AircraftUser.new

    @id = params[:id]
  end

  # GET /aircraft_users/1/edit
  def edit
  end

  # POST /aircraft_users or /aircraft_users.json
  def create
    @aircraft_user = AircraftUser.new(aircraft_user_params)
   
    if @aircraft_user.save
      flash[:notice] = "Aircraft and User map was successfully created."
      redirect_to aircraft_users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /aircraft_users/1 or /aircraft_users/1.json
  def update
    respond_to do |format|
      if @aircraft_user.update(aircraft_user_params)
        format.html { redirect_to aircraft_user_url(@aircraft_user), notice: "Aircraft user was successfully updated." }
        format.json { render :show, status: :ok, location: @aircraft_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @aircraft_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aircraft_users/1 or /aircraft_users/1.json
  def destroy
    @aircraft_user.destroy

    respond_to do |format|
      format.html { redirect_to aircraft_users_url, notice: "Aircraft user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aircraft_user
      @aircraft_user = AircraftUser.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def aircraft_user_params
      params.require(:aircraft_user).permit(:user_id, :aircraft_id)
    end
end
