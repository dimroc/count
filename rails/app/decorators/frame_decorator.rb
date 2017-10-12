class FrameDecorator < ApplicationDecorator
  delegate_all

  def image_tag
    h.ix_image_tag(object.image.url, { sizes: "180px" }) if object.image
  end

  def created_at
    l object.created_at, format: :calendar_timezone
  end
end
