class Admin::MallsController < ApplicationController
  include AdminControllable

  def index
    @predictions = Prediction::Mall.desc.page(params[:page])
  end
end
