class ShakecamsController < ApplicationController
  def index
    @frames = Frame::Shakecam.v2.last(10)
    render json: @frames
  end
end
