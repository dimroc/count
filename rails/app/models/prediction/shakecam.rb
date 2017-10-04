class Prediction::Shakecam < Prediction
  class << self
    def predict!
      now = DateTime.now.to_i
      url = "https://cdn.shakeshack.com/camera.jpg?#{now}"
      prediction = create!(snapshot: open(url), created_at: now)
      reply = RPC::Client.default.count_line(prediction.snapshot[:cropped].read)
      prediction.update_attributes!(density_map: StringIO.new(reply.density_map),
                                    version: reply.version,
                                    crowd_count: reply.crowd_count,
                                    line_count: reply.line_count)
      prediction
    rescue StandardError, RuntimeError
      prediction.destroy if prediction.present? and !prediction.destroyed?
      raise
    end
  end
end
