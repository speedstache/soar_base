class Flight < ApplicationRecord
  belongs_to :reservation
  belongs_to :aircraft
  belongs_to :user

  validates :tow_height, numericality: {greater_than_or_equal_to: 100,  only_integer: true }

  # method to determine the price of a tow based on a tow height

  def calcfees
    calcfees = 0
    rowfee = 0
    Towfee.pluck(:id).each do |id|
      calcfees += rowfee
      towfee = Towfee.find(id)
        if ( self.tow_height - towfee.min_height ) >= ( towfee.max_height - towfee.min_height ) && ( self.tow_height - towfee.min_height ) > 0
          rowfee =  ( ( towfee.max_height - towfee.min_height ) / 100 ) * towfee.price_per
        elsif ( self.tow_height - towfee.min_height ) < ( towfee.max_height - towfee.min_height ) && ( self.tow_height - towfee.min_height ) > 0
          rowfee =  ( ( self.tow_height - towfee.min_height ) / 100 ) * towfee.price_per
        else
          rowfee =  0
        end
      end
    return calcfees
  end


end
