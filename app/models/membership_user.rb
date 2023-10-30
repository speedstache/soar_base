class MembershipUser < ApplicationRecord
  before_validation :set_defaults
  belongs_to :user
  belongs_to :membership
  validates :membership_id, presence: true
  validates :renewal_date, presence: true


  def set_defaults
    self.membership_id ||= 4
  end



end
