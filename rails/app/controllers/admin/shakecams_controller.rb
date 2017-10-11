class Admin::ShakecamsController < ApplicationController
  include AdminControllable

  def index
    @frames = Frame::Shakecam.eager.desc.page(params[:page])
  end
end
