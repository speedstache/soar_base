module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def has_privileges_in
    
    # will need to limit this to users that have active memberships once available
    aircraftuser_ids = AircraftUser.where(user_id: User.where(id: current_user.id).ids)
      has_privileges_in = []
      aircraftuser_ids.each do |aircraftuser_id|
        has_privileges_in << { id: AircraftUser.find(aircraftuser_id.id).aircraft.id, short_name: AircraftUser.find(aircraftuser_id.id).aircraft.short_name }
      end
    return has_privileges_in
  
  end

  # Check the current user for an active membership
  def has_membership

    active_member = MembershipUser.where(user_id: current_user.id).last
      if !active_member.nil? 
        next_renewal_date = active_member.renewal_date + active_member.membership.renewal_period
        if Date.today <= next_renewal_date && active_member.active_flag == true
          has_membership = true
        else
          has_membership = false
        end
      else
        has_membership = false
      end
    end
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end


  # return the next flying day after today, or today if the date is the same
  def next_flying_day
    find_date = Day.order('days.day ASC').where(day: Date.today.., active_flag: true).first
    
    next_flying_day = find_date.day
  end

  # return the previous flying day before today
  def previous_flying_day
    find_date = Day.order('days.day ASC').where(day: ...Date.today, active_flag: true).last
    
    previous_flying_day = find_date.day
  end

   # return the previous tow log (tach_end) before today
   def previous_tow_log
    if Tow.order('tows.tow_date ASC').where(tow_date: ...Date.today).last.present?
      find_date = Tow.order('tows.tow_date ASC').where(tow_date: ...Date.today).last
      previous_tow_log = find_date.tach_end
    else
      previous_tow_log = 0
    end    
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def require_user_admin
    if !current_user.permission.user_admin?
    flash[:danger] = "That area requires user admin rights"
    redirect_to reservations_url
    end
  end

  def require_club_admin
    if !current_user.permission.club_admin?
    flash[:danger] = "That area requires club admin rights"
    redirect_to reservations_url
    end
  end

  def require_site_admin
    if !current_user.permission.site_admin?
    flash[:danger] = "That area requires site admin rights"
    redirect_to reservations_url
    end
  end

  def require_towpilot
    if !current_user.permission.towpilot?
    flash[:danger] = "That area requires tow pilot rights"
    redirect_to reservations_url
    end
  end

  def require_commercial
    if !current_user.permission.commercial?
    flash[:danger] = "That action requires commercial pilot rights"
    redirect_to reservations_url
    end
  end

  def require_instructor
    if !current_user.permission.instructor?
    flash[:danger] = "That action requires instructor rights"
    redirect_to reservations_url
    end
  end

  def require_field_status
    if current_user.permission.site_admin? || current_user.permission.club_admin? || current_user.permission.instructor? || current_user.permission.towpilot? || current_user.permission.commercial?
    else
      flash[:danger] = "Insufficient privileges for sending field status update"
      redirect_to reservations_url
    end
  end

  def is_pilot_admin
    if current_user.permission.site_admin? || current_user.permission.user_admin? || current_user.permission.instructor? || current_user.permission.commercial? 
    is_pilot_admin = true
    else
    is_pilot_admin = false
    end
    return is_pilot_admin
  end
  
end