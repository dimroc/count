class Admin::PredictionsController < ApplicationController
  include AdminControllable

  def index
    @predictions = Prediction.desc.page(params[:page])
  end
end
