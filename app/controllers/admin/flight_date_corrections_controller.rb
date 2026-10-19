class Admin::FlightDateCorrectionsController < ApplicationController
  before_action :require_user
  before_action :require_user_admin
  before_action :set_flight

  def edit
    @reservation = @flight.reservation
  end

  def update
    @reservation = @flight.reservation
    correction = date_correction_params

    if correction[:reservation_date].blank? || correction[:flight_date].blank?
      flash.now[:alert] = "Both dates are required."
      return render :edit, status: :unprocessable_entity
    end

    reservation_date = Date.iso8601(correction[:reservation_date])
    flight_date = Date.iso8601(correction[:flight_date])

    ActiveRecord::Base.transaction do
      @reservation.lock!
      @flight.reload

      if @reservation.reservation_date != reservation_date
        @reservation.update!(reservation_date: reservation_date)
        @reservation.flights.update_all(flight_date: @reservation.reservation_date, updated_at: Time.current)
        @reservation.tows.update_all(tow_date: @reservation.reservation_date, updated_at: Time.current)
      elsif @flight.flight_date != flight_date
        @flight.update!(flight_date: flight_date)
      end
    end

    redirect_to admin_flights_path, notice: "Flight and reservation dates were corrected."
  rescue ActiveRecord::RecordInvalid => error
    flash.now[:alert] = error.record.errors.full_messages.to_sentence
    render :edit, status: :unprocessable_entity
  rescue Date::Error
    @reservation ||= @flight.reservation
    flash.now[:alert] = "Enter valid dates."
    render :edit, status: :unprocessable_entity
  end

  private

  def set_flight
    @flight = Flight.find(params[:id])
  end

  def date_correction_params
    params.require(:date_correction).permit(:reservation_date, :flight_date)
  end
end