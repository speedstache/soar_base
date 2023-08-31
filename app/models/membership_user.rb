class MembershipUser < ApplicationRecord
  belongs_to :membership
  belongs to :user
end
