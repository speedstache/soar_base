class Aircraft < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3, maximum: 30 }
  validates_uniqueness_of :name
  validates_uniqueness_of :name , scope: [ :short_name ]
  validates :group, inclusion: { in: [ "club", "private", "towplane", "instructor", "commercial" ], allow_blank: true, message: "not an allowable aircraft type" }
  has_many :aircraft_users
  has_many :users, through: :aircraft_usersr
  has_many :reservations
  has_many :flights
  has_many :tows
end
