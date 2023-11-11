class Permission < ApplicationRecord
  before_validation :set_defaults
  belongs_to :user

  def set_defaults
    self.instructor ||= false
    self.towpilot ||= false
    self.user_admin ||= false 
    self.club_admin ||= false
    self.site_admin ||= false
    self.global_admin ||= false
  end

end

  private 

  