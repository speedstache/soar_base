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
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
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
  
end