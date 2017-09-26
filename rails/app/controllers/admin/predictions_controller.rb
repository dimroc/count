class Admin::PredictionsController < ApplicationController
  include AdminControllable

  def index
    @predictions = Prediction.desc.eager.page(params[:page])
  end
end
