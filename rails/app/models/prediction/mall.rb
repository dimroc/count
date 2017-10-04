class Prediction::Mall < Prediction
  class << self
    def predict!(url)
      io = open(url)
      reply = RPC::Client.default.count_crowd(io.read)
      io.rewind
      create!(snapshot: io,
              density_map: StringIO.new(reply.density_map),
              version: reply.version,
              crowd_count: reply.crowd_count)
    end
  end
end
