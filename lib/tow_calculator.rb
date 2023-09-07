class TowCalculator

  def fees
    @towfees = Towfee.all
    
    @tow_incremental = 0
    @towtal = 0 

    @towfees.each do |towfee|  
      @towtal = @towtal + @tow_incremental
      if
      ( @flight.tow_height - towfee.min_height ) >= ( towfee.max_height - towfee.min_height )
      @tow_incremental = ( (towfee.max_height - towfee.min_height ) / 100 ) * towfee.price_per
      elsif
        ( @flight.tow_height - towfee.min_height ) < ( towfee.max_height - towfee.min_height ) && ( @flight.tow_height - towfee.min_height ) > 0
        @tow_incremental = ( (towfee.max_height - towfee.min_height ) / 100 ) * towfee.price_per
      else
        @tow_incremental = 0
      end
    end
  end

end