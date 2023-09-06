class MembershipUser < ApplicationRecord
  belongs_to :membership
  belongs_to :user
end
