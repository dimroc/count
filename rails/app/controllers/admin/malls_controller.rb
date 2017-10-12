class Admin::MallsController < ApplicationController
  include AdminControllable

  def index
    @frames = Frame::Mall.eager.desc.page(params[:page])
  end
end
