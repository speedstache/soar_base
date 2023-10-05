class FlightsController < ApplicationController
  before_action :require_user
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :set_flight, only: %i[ show edit update destroy ]
  before_action :set_reservation

  # GET /flights or /flights.json
  def index
    @flights = Flight.all
    @towtal
  end

  # GET /flights/1 or /flights/1.json
  def show
  end

  # GET /flights/new
  def new
    @flight = Flight.new
  end

  # GET /flights/1/edit
  def edit
  end

  # POST /flights or /flights.json
  def create
    @flight = Flight.new(flight_params)
    @flight.reservation_id = @reservation.id
    @flight.flight_date = @reservation.reservation_date
    @flight.user_id = @reservation.user_id
    @flight.aircraft_id = @reservation.aircraft_id

    respond_to do |format|
      if @flight.save

        @flight.update({'fees': @flight.calcfees})

        format.html { redirect_to reservation_path(@reservation), notice: "Flight was successfully created." }
        format.json { render :show, status: :created, location: @flight }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flights/1 or /flights/1.json
  def update
    respond_to do |format|
      if @flight.update(flight_params)
        @flight.update({'fees': @flight.calcfees})
        format.html { redirect_to reservation_path(@reservation), notice: "Flight was successfully updated." }
        format.json { render :show, status: :ok, location: @flight }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @flight.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flights/1 or /flights/1.json
  def destroy
    @flight.destroy

    respond_to do |format|
      format.html { redirect_to flights_url, notice: "Flight was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flight
      @flight = Flight.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def flight_params
      params.require(:flight).permit(:tow_height, :flight_time, :rope_break, :fees)
    end

    def set_reservation
      @reservation = Reservation.find(params[:reservation_id])
    end

    def require_same_user
      @flight = Flight.find(params[:id])
      if current_user.id != @flight.user_id && !current_user.permission.club_admin?
      flash[:alert] = "You can only edit or delete your own flights"
      redirect_to reservations_path
      end
    end	

end
