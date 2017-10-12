class Frame::Mall < Frame
  include ImageUploader[:raw]

  class << self
    def predict!(url)
      frame = create!(raw: open(url))
      frame.predict!(version: 1)
      frame.predict!(version: 2)
      frame
    end
  end

  def image
    raw
  end

  def predict!(version: 2)
    create_prediction! RPC::Client.new(version).count_crowd(image.read)
  end
end
