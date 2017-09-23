class Prediction::Shakecam < Prediction
  class << self
    def fetch!
      now = DateTime.now.to_i
      url = "https://cdn.shakeshack.com/camera.jpg?#{DateTime.now().to_i}"
      destination = "shakecam-#{now}.jpg"
      prediction = create!
      prediction.snapshot.attach io: open(url), filename: destination, content_type: "image/jpg"
      prediction
    end
  end

  def predict!

  end
end
