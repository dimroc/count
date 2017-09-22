class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  around_action :with_time_zone, if: :current_user

  private

  def with_time_zone
    Time.use_zone(current_user.timezone) { yield }
  end
end
