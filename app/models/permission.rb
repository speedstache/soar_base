class Permission < ApplicationRecord
  before_validation :set_defaults
  belongs_to :user



  private 

  def set_defaults
    user_admin = false if user_admin.blank?
    club_admin = false if club_admin.blank?
    site_admin = false if site_admin.blank?
    global_admin = false if global_admin.blank?
  end

end
