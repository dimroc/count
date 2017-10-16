class ShakecamsController < ApplicationController
  def index
    @frames = Frame::Shakecam.v2.day(1.day.ago)
    render json: {
      frames: ActiveModelSerializers::SerializableResource.new(@frames),
      stats: stats
    }
  end

  private

  def stats
    {
      count: Frame::Shakecam.v2.count,
      days: (Frame::Shakecam.v2.first.created_at.to_date - Frame::Shakecam.v2.last.created_at.to_date).to_i
    }
  end
end
