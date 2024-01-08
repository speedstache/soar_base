class NoFlyDay < ApplicationJob
  queue_as :default

  def perform

    #automatically change status of reservations on days where field status indicates no flying to 'noflyday'  
    if FieldStatusUpdate.where(date: Date.today).present?  
      noflystatus = FieldStatusUpdate.where(date: Date.today).last
        if noflystatus.ops_status == false

          noflyreservations = Reservation.where(reservation_date: noflystatus.date)

          noflyreservations.each do |noflyreservation|
            noflyreservation.update(status: 'noflyday')
            noflyreservation.save

          end
        else
          #if latest FieldStatusUpdate is true, we're flying and won't change any reservation statuses
        end
    else
      #if there are no FieldStatusUpdates for today, don't run this update
    end

  end

end 