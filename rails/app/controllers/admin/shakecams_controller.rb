class Admin::ShakecamsController < ApplicationController
  include AdminControllable

  def index
    @predictions = Prediction::Shakecam.desc.page(params[:page])
  end
end
