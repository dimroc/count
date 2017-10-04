class Prediction::Shakecam < Prediction
  class << self
    def fetch!
      url = "https://cdn.shakeshack.com/camera.jpg?#{DateTime.now.to_i}"
      create!(snapshot: open(url))
    end
  end

  def predict!
    reply = rpcclient.count_crowd(snapshot[:cropped].read)
    update_attributes!(density_map: StringIO.new(reply.density_map),
                       version: reply.version,
                       crowd_count: reply.crowd_count,
                       line_count: reply.line_count)
  end

  def to_s
    "Version: #{version}, Crowd: #{crowd_count}, Line: #{line_count}"
  end

  private

  def rpcclient
    @rpcclient ||= RPC::Client.default
  end
end
