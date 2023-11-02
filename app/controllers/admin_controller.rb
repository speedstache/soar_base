class AdminController < ApplicationController

  def reservations
    @reservations = Reservation.where(reservation_date: Date.today.beginning_of_year..Date.today)

    

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
        flash[:notice] = "Changes were successfully logged."
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


  private

  def reservation_params
    params.require(@reservation).permit(:status, :method, :description)
  end

end