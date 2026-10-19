class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper

  def require_user
    if !logged_in?
      flash[:warning] = "You must be logged in to perform that action"
      redirect_to login_path
    end
  end

  def return_path(fallback)
    candidate = params[:return_to].presence || params[:previous_request].presence || request.referer
    return fallback if candidate.blank?

    uri = URI.parse(candidate)
    if uri.host
      return fallback unless uri.host == request.host && uri.port == request.port
    else
      return fallback unless uri.path&.start_with?("/") && !uri.path.start_with?("//")
    end

    path = uri.path.presence || "/"
    path += "?#{uri.query}" if uri.query.present?
    path
  rescue URI::InvalidURIError, TypeError
    fallback
  end
  
end
