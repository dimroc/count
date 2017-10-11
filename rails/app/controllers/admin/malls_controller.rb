class Admin::MallsController < ApplicationController
  include AdminControllable

  def index
    @frame = Frame::Mall.eager.desc.page(params[:page])
  end
end
