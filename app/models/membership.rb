class Membership < ApplicationRecord
  has_many :membership_users
  has_many :users, through: :users
end
