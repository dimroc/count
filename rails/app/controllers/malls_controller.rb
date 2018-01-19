class MallsController < ApplicationController
  def index
    @frames = FrameDecorator.decorate_collection(Frame::Mall.eager.desc.limit(10))
    @frames.reverse!
  end
end
