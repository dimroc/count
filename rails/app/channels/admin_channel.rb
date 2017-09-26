class AdminChannel < ApplicationCable::Channel
  before_subscribe :authorize_admin!

  def subscribed
    stream_from "admin_#{params[:room]}"
  end

  def authorize_admin!
    reject_unauthorized_connection unless current_user.present? and current_user.admin?
  end
end
