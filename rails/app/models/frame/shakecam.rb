class Frame::Shakecam < Frame
  include ShakecamUploader[:raw]

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
  end

  def image
    raw[:cropped] if raw.respond_to? :keys
  end

  def predict!(version: 2)
    reply = RPC::Client.new(version).count_line(image.read)
    predictions.create!(density_map: StringIO.new(reply.density_map),
                        version: reply.version,
                        crowd_count: reply.crowd_count,
                        line_count: reply.line_count)
  end
end
