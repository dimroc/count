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
      count: Frame::Shakecam.count,
      days: 44
    }
  end
end
