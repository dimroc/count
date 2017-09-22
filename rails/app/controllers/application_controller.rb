class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  around_action :with_time_zone, if: :current_user
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def with_time_zone
    Time.use_zone(current_user.timezone) { yield }
  end

  def user_not_authorized
    render file: 'public/403.html', status: 403
  end
end
