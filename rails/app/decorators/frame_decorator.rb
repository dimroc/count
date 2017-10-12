class FrameDecorator < ApplicationDecorator
  delegate_all

  def image_tag
    if object.image
      h.link_to(object.image.url) do
        h.ix_image_tag(object.image.url, { sizes: "180px" })
      end
    end
  end

  def created_at
    l object.created_at, format: :calendar_timezone
  end
end
