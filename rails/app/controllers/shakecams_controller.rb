class ShakecamsController < ApplicationController
  def index
    render json: {
      frames: [
        ActiveModelSerializers::SerializableResource.new(with_closed_frame(Frame::Shakecam.v2.today)),
        ActiveModelSerializers::SerializableResource.new(Frame::Shakecam.v2.day(1.day.ago)),
        ActiveModelSerializers::SerializableResource.new(Frame::Shakecam.v2.day(2.days.ago)),
        ActiveModelSerializers::SerializableResource.new(Frame::Shakecam.v2.day(3.days.ago)),
        ActiveModelSerializers::SerializableResource.new(Frame::Shakecam.v2.day(4.days.ago)),
      ],
      stats: stats
    }
  end

  private

  def with_closed_frame(relation)
    if relation.blank?
      [Frame::Shakecam.v2.first.tap { |f| f.closed = true }]
    else
      relation
    end
  end

  def stats
    {
      count: Frame::Shakecam.v2.count,
      days: (Frame::Shakecam.v2.first.created_at.to_date - Frame::Shakecam.v2.last.created_at.to_date).to_i
    }
  end
end
