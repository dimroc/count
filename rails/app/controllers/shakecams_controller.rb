class ShakecamsController < ApplicationController
  def index
    @frames = Frame::Shakecam.v2.first(10)
    render json: @frames
  end
end
