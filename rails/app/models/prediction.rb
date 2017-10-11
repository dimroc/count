class Prediction < ApplicationRecord
  include ImageUploader[:density_map]
  belongs_to :frame

  self.inheritance_column = :somthing

  def to_s
    "Version: #{version}, Crowd: #{crowd_count}, Line: #{line_count}"
  end

  private

  def rpcclient
    @rpcclient ||= RPC::Client.default  # Get client based on version
  end
end
