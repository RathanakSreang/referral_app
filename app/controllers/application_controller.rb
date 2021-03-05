class ApplicationController < ActionController::API
  def auth_header
    request.headers["AccessToken"]
  end

  def current_access_tokens
    return unless auth_header.present?

    @current_access_tokens ||= AccessToken.find_by token: auth_header
  end

  def current_user
    return unless current_access_tokens

    @current_user ||= current_access_tokens.user
  end

  def logged_in?
    !!current_user
  end

  def authorized
    return if logged_in?

    render_errors([], :unauthorized)
  end
end
