class Prediction::Shakecam < Prediction
  class << self
    def fetch!
      now = DateTime.now.to_i
      url = "https://cdn.shakeshack.com/camera.jpg?#{now}"
      create!(snapshot: open(url), created_at: now)
    end
  end

  def predict!
    reply = rpcclient.count_line(snapshot[:cropped].read)
    update_attributes!(density_map: StringIO.new(reply.density_map),
                       version: reply.version,
                       crowd_count: reply.crowd_count,
                       line_count: reply.line_count)
  end
end
