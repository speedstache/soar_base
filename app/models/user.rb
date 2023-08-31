class User < ApplicationRecord
  before_save { self.email = email.downcase }
  has_many :membership_users
  has_many :flights
  has_many :reservations
  has_many :flights, through: :reservations
  has_many :aircraft_users
  has_many :aircrafts, through: :aircraft_users
  validates :username, presence: true, 
                      uniqueness: { case_sensitive: false }, 
                      length: { minimum: 3, maximum: 25 }
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, presence: true, length: { maximum: 105 },
                      uniqueness: { case_sensitive: false }, 
                      format: { with: VALID_EMAIL_REGEX }  
  has_secure_password
end
