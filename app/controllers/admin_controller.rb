class AdminController < ApplicationController
  before_action :require_user

  def reservations
    #show all reservations in private aircraft and club aircraft, exclude instructor and towplane logs
    #show all reservations from the past 400 days. Will improve this with more flexibility but it works for now.
    @validaircraft = Aircraft.where(group: 'private').or(Aircraft.where(group: 'club'))
    @reservations = Reservation.where(reservation_date: 400.days.ago..Date.today, aircraft_id: @validaircraft)
    #exclude three records that were used to back-date aircraft hours when site was set up
    @reservations = @reservations.where.not(id => [128,129,127])

    respond_to do |format|
      format.html
      format.csv {send_data @reservations.to_csv, filename: "ESC_reservation_logs_#{Date.today}.csv" }
    end

    def edit
      @reservation = Reservation.find(params[:id])
    end

    def update
      @reservation = Reservation.find(params[:id])

      if @reservation.update(reservation_params)
        flash[:success] = "Changes were successfully logged."
        format.html { redirect_to admin_reservations_path }
      else
        render :new, status: :unprocessable_entity
      end
    end

  end
  
    def aircrafts
  end

  def instructors
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

  def email_request_params
    params.require(@email_request).permit(:archive)
  end


end