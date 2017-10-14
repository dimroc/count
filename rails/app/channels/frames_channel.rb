class FramesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "#{params[:room]}"
  end
end
