class TowsController < ApplicationController
  before_action :set_tow, only: %i[ show edit update destroy ]
  before_action :require_user
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :set_reservation

  # GET /tows or /tows.json
  def index
    @tows = Tow.all
  end

  # GET /tows/1 or /tows/1.json
  def show
  end

  # GET /tows/new
  def new
    @tow = Tow.new
  end

  # GET /tows/1/edit
  def edit
  end

  # POST /tows or /tows.json
  def create
    @tow = Tow.new(tow_params)
    @tow.reservation_id = @reservation.id
    @tow.tow_date = @reservation.reservation_date
    @tow.user_id = @reservation.user_id
    @tow.aircraft_id = @reservation.aircraft_id

    respond_to do |format|
      if @tow.save
        format.html { redirect_to reservations_tow_path, notice: "Tow log was successfully added." }
        format.json { render :show, status: :created, location: @tow }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tows/1 or /tows/1.json
  def update
    respond_to do |format|
      if @tow.update(tow_params)
        format.html { redirect_to reservations_tow_path, notice: "Tow log was successfully updated." }
        format.json { render :show, status: :ok, location: @tow }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tows/1 or /tows/1.json
  def destroy
    @tow.destroy

    respond_to do |format|
      format.html { redirect_to reservations_tow_path, notice: "Tow log was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tow
      @tow = Tow.find(params[:id])
    end

    def set_reservation
      @reservation = Reservation.find(params[:reservation_id])
    end

    # Only allow a list of trusted parameters through.
    def tow_params
      params.require(:tow).permit(:tows, :releases, :tach_end, :tach_start, :fuel_added, :oil_added)
    end

    def require_same_user
      @tow = Tow.find(params[:id])
      if current_user.id != @tow.user_id && !current_user.permission.club_admin?
      flash[:alert] = "You can only edit or delete your own tow logs"
      redirect_to reservations_tow_path
      end
    end	
end
