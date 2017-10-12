class Prediction < ApplicationRecord
  include ImageUploader[:density_map]
  belongs_to :frame

  def to_s
    "Version: #{version}, Crowd: #{crowd_count}, Line: #{line_count}"
  end
end
