class AircraftUser < ApplicationRecord
  has_one :aircraft
  belongs_to :user


end
