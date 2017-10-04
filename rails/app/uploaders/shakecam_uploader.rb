require "image_processing/mini_magick"

class ShakecamUploader < PredictionUploader
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions

  process(:store) do |io, context|
    original = io.download
    {original: io, cropped: crop!(original, 720, 720, 0, 0)}
  end
end
