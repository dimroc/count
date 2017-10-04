class PredictionDecorator < ApplicationDecorator
  delegate_all

  def image_tag
    h.ix_image_tag(object.snapshot[:cropped].url, { sizes: "180px" }) if object.snapshot
  end

  def density_map_tag
    h.ix_image_tag(object.density_map.url, { sizes: "180px" }) if object.density_map
  end

  def created_at
    l object.created_at, format: :calendar_timezone
  end

  def crowd_count
    h.number_with_precision object.crowd_count, precision: 2
  end

  def line_count
    h.number_with_precision object.line_count, precision: 2
  end
end
