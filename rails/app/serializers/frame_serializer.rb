class FrameSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :line_count, :crowd_count,
    :density_map_url, :image_url, :closed

  def line_count
    object.v2_predictions.last.line_count
  end

  def crowd_count
    object.v2_predictions.last.crowd_count
  end

  def density_map_url
    h.ix_image_url object.v2_predictions.last.density_map.url
  end

  def image_url
    h.ix_image_url object.image.url
  end

  private

  def h
    ActionController::Base.helpers
  end
end
