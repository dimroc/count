class ShakecamsController < ApplicationController
  def index
    render json: {
      frames: [
        serialize(with_closed_frame(Frame::Shakecam.v2.asc.day(date_param))),
        serialize(Frame::Shakecam.v2.asc.day(date_param - 1.day)),
        serialize(Frame::Shakecam.v2.asc.day(date_param - 2.days)),
        serialize(Frame::Shakecam.v2.asc.day(date_param - 3.days)),
      ].compact
    }
  end

  private

  def date_param
    @date_param ||= Date.parse(params[:date])
  end

  def serialize(value)
    ActiveModelSerializers::SerializableResource.new(value)
  end

  def with_closed_frame(relation)
    if relation.blank?
      [Frame::Shakecam.v2.asc.last].compact
    else
      relation
    end
  end
end
