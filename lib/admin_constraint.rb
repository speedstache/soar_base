class AdminConstraint
  def matches?(request)
    return false unless request.session[:user_id]
    user = User.find_by_id(request.session[:user_id])
    user && user.permission.site_admin?
  end
end 