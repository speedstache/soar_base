class ReservationsController < ApplicationController
  helper_method :current_user, :logged_in?
  before_action :set_reservation, only: %i[ show edit update destroy ]
  before_action :require_same_user, only: [:edit, :update, :destroy]
 

  # GET /reservations or /reservations.json
  def index
    @avail_hours = Hour.where(active_flag: 1)
    @view_21a = Reservation.where(reservation_date: Date.today, aircraft_id: 1)
    @view_21b = Reservation.where(reservation_date: Date.today, aircraft_id: 2)
    @view_23 = Reservation.where(reservation_date: Date.today, aircraft_id: 3)
    @reservations = current_user.reservations.where(reservation_date: 3.days.ago..30.days.from_now)
  end


  # GET /reservations/1 or /reservations/1.json
  def show
    @reservation = Reservation.find(params[:id])
  end

  # GET /reservations/new
  def new
    @avail_days = Day.where(day: Date.today .. 30.days.from_now, active_flag: 1).order('days.day ASC')
    @avail_hours = Hour.where(active_flag: 1)
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations or /reservations.json
  def create
    @avail_days = Day.where(day: Date.today .. 60.days.from_now)
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

    def require_same_user
      if current_user != @reservation.user_id && !current_user.permission.club_admin?
      flash[:alert] = "You can only edit or delete your own article"
      redirect_to @reservation
      end
    end	

    

end
