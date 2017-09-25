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
    puts "#{image.key}: #{io.size}"
    puts rpcclient.count_crowd(io)
  end

  private

  def bucket
    @bucket ||= snapshot.service.bucket
  end

  def rpcclient
    @rpcclient ||= RPC::Client.new
  end
end
