class Tow < ApplicationRecord
  belongs_to :reservation
  belongs_to :aircraft
  belongs_to :user
  
end
