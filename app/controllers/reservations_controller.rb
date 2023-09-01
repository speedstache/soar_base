class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[ show edit update destroy ]
  helper_method :current_user, :logged_in?

  # GET /reservations or /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1 or /reservations/1.json
  def show
    @reservation = Reservation.find(params[:id])
  end

  # GET /reservations/new
  def new
    @avail_hours = Hour.where(active_flag: 1)
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations or /reservations.json
  def create
    @avail_hours = Hour.where(active_flag: 1)
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      flash[:notice] = "Reservation was successfully created."
      redirect_to reservations_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to reservation_url(@reservation), notice: "Reservation was successfully updated." }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url, notice: "Reservation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation).permit(:user_id, :reservation_date, :reservation_time, :reservation_duration, :aircraft_id, :instructor_flag)
    end

end
