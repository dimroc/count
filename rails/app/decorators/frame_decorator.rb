class FrameDecorator < ApplicationDecorator
  delegate_all

  def image_tag
    if object.image
      h.link_to(object.image.url) do
        h.ix_image_tag(path_for(object.image.url), widths: [180])
      end
    end
  end

  def created_at
    l object.created_at, format: :calendar_timezone
  end
end
