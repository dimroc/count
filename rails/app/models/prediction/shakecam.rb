class Prediction::Shakecam < Prediction
  class << self
    def fetch!
      prediction = create!
      timestamp = prediction.created_at.to_i
      url = "https://cdn.shakeshack.com/camera.jpg?#{timestamp}"
      destination = "shakecam-#{timestamp}.jpg"
      prediction.snapshot.attach(io: open(url), filename: destination, content_type: "image/jpg")
      prediction.image.processed
      prediction
    rescue MiniMagick::Error
      prediction.destroy if prediction
      raise
    end
  end

  def image
    snapshot.variant(crop: "720x720+0+0")
  end

  def predict!
    io = bucket.file(image.key).download
    reply = rpcclient.count_crowd(io)
    timestamp = created_at.to_i
    self.density_map.attach(io: StringIO.new(reply.density_map),
                       filename: "densitymap-#{timestamp}.jpg",
                       content_type: "image/jpg")

    update_attributes!(version: reply.version,
                       crowd_count: reply.crowd_count,
                       line_count: reply.line_count)
  end

  def to_s
    "Version: #{version}, Crowd: #{crowd_count}, Line: #{line_count}"
  end

  private

  def bucket
    @bucket ||= snapshot.service.bucket
  end

  def rpcclient
    @rpcclient ||= RPC::Client.default
  end
end
