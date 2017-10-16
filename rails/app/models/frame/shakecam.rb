class Frame::Shakecam < Frame
  include ShakecamUploader[:raw]

  scope :day, -> (day) { where(created_at: working_hours(day)) }
  scope :today, -> { where(created_at: working_hours(DateTime.now).begin..DateTime.now) }

  class << self
    def predict!
      now = DateTime.now.to_i
      url = "https://cdn.shakeshack.com/camera.jpg?#{now}"
      frame = create!(raw: open(url), created_at: now)
      frame.predict!(version: 1)
      frame.predict!(version: 2)
      frame
    rescue StandardError, RuntimeError, Google::Apis::ServerError
      frame.destroy if frame.present? and !frame.destroyed?
      raise
    end

    def working_hours(day)
      tomorrow = day + 1.day
      day.in_time_zone(timezone).change(hour: 8, min: 0, sec: 0)..tomorrow.in_time_zone(timezone).end_of_day
    end
  end

  def image
    raw[:cropped] if raw.respond_to? :keys
  end

  def predict!(version: 2)
    create_prediction! RPC::Client.new(version).count_line(image.read)
  end
end
