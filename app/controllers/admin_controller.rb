class AdminController < ApplicationController

  def reservations
    @reservations = Reservation.all

    

    respond_to do |format|
      format.html
      format.csv {send_data @reservations.to_csv, filename: "ESC_reservation_logs_#{Date.today}.csv" }
    end

  end
  
    def aircrafts
  end

  def instructors
  end

end