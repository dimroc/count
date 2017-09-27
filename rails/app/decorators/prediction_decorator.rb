class PredictionDecorator < ApplicationDecorator
  delegate_all

  def image_tag
    h.image_tag(object.image, width: 180, height: 180) if object.snapshot.attached?
  end

  def density_map_tag
    h.image_tag(object.density_map) if object.density_map.attached?
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
