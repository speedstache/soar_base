class AdminController < ApplicationController
  before_action :require_user

  def reservations
    #show all reservations in private aircraft and club aircraft, exclude instructor and towplane logs
    #show all reservations from the past 400 days. Will improve this with more flexibility but it works for now.
    @validaircraft = Aircraft.where(group: 'private').or(Aircraft.where(group: 'club'))
    @reservations = Reservation.where(reservation_date: 400.days.ago..Date.today, aircraft_id: @validaircraft).order('reservations.reservation_date DESC','reservations.id DESC')

    respond_to do |format|
      format.html
      format.csv {send_data @reservations.reservation_to_csv, filename: "ESC_reservation_logs_#{Date.today}.csv" }
    end

    def editreservation
      @reservation = Reservation.find(params[:id])
    end

    def updatereservation
      @reservation = Reservation.find(params[:id])

      if @reservation.update(reservation_params)
        flash[:success] = "Changes were successfully logged."
        format.html { redirect_to admin_reservations_path }
      else
        render :new, status: :unprocessable_entity
      end
    end

    # DELETE /reservations/1 or /reservations/1.json
    def destroy
      @reservation = Reservation.find(params[:id])
      @reservation.destroy

      respond_to do |format|
        flash[:success] = "Reservation was successfully deleted."
        format.html { redirect_to admin_reservations_path }
        format.json { head :no_content }
     end
    end


  end

  def flights
    @flights = Flight.where(flight_date: 400.days.ago..Date.today).order('flights.flight_date DESC','flights.reservation_id DESC')

    respond_to do |format|
      format.html
      format.csv {send_data @flights.flight_to_csv, filename: "ESC_flight_logs_#{Date.today}.csv" }
    end

    def editflight
      @editflight = Flight.find(params[:id])
    end

    def update
      @editflight = Flight.find(params[:id])

      if @editflight.update(flight_params)
        flash[:success] = "Changes were successfully logged."
        format.html { redirect_to admin_flights_path }
      else
        render :new, status: :unprocessable_entity
      end
    end

  end
  
  def aircrafts
  end

  def instructors
    @instructorflights = Flight.where.not(instructor_id: nil)
    @flights = @instructorflights.where(flight_date: 400.days.ago..Date.today).order('flights.flight_date DESC','flights.reservation_id DESC')

    respond_to do |format|
      format.html
      format.csv {send_data @flights.instructor_to_csv, filename: "ESC_instructor_logs_#{Date.today}.csv" }
    end

    def editinstructor
      @editinstructor = Flight.find(params[:id])
    end

    def update
      @editinstructor = Flight.find(params[:id])

      if @editinstructor.update(flight_params)
        flash[:success] = "Changes were successfully logged."
        format.html { redirect_to admin_instructors_path }
      else
        render :new, status: :unprocessable_entity
      end
    end


  end

  def towpilots
    #show all reservations related to towplane logs
    #show all reservations from the past 400 days. Will improve this with more flexibility but it works for now.
    @validaircraft = Aircraft.where(group: 'towplane')
    @reservations = Reservation.where(reservation_date: 400.days.ago..Date.today, aircraft_id: @validaircraft).order('reservations.reservation_date DESC','reservations.id DESC')

    respond_to do |format|
      format.html
      format.csv {send_data @reservations.towpilot_to_csv, filename: "ESC_towpilot_logs_#{Date.today}.csv" }
    end

    def editreservation
      @reservation = Reservation.find(params[:id])
    end

    def updatereservation
      @reservation = Reservation.find(params[:id])

      if @reservation.update(reservation_params)
        flash[:success] = "Changes were successfully logged."
        format.html { redirect_to admin_reservations_path }
      else
        render :new, status: :unprocessable_entity
      end
    end

    # DELETE /reservations/1 or /reservations/1.json
    def destroy
      @reservation = Reservation.find(params[:id])
      @reservation.destroy

      respond_to do |format|
        flash[:success] = "Reservation was successfully deleted."
        format.html { redirect_to admin_reservations_path }
        format.json { head :no_content }
     end
    end

  end

  def emails

    @active_email_requests = EmailRequest.where(archive: false).paginate(page: params[:page], per_page: 10)
    @archived_email_requests = EmailRequest.where(archive: true).paginate(page: params[:page], per_page: 10)

    def edit
      @email_request = EmailRequest.find(params[:id])
    end

    def update
      @email_request = EmailRequest.find(params[:id])

      if @email_request.update(email_request_params)
        flash[:success] = "Email has been archived from admin controller"
        format.html { redirect_to admin_email_requests_path }
      else
        render :new, status: :unprocessable_entity
      end
    end

  end

  def edit_email

  end

  def delete_email

  end

  private

  def reservation_params
    params.require(@reservation).permit(:status, :method, :description)
  end

  def flight_params
    params.require(@editflight).permit(:aircraft_id, :tow_height, :flight_time, :rope_break, :fees, :instructor_id, :reservation_id, :previous_request)
  end

  def email_request_params
    params.require(@email_request).permit(:archive)
  end


end