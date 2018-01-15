class MallsController < ApplicationController
  def index
    @frames = Frame::Mall.eager.desc.limit(10).decorate
    @frames.reverse!
  end
end
