class EmailRequest < ApplicationRecord

  def set_defaults
    self.ride ||= false
    self.general ||= false
    self.instruction ||= false
    self.membership ||= false 
    self.archive ||= false

  end


  
end