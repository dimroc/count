require "image_processing/mini_magick"

class SnapshotUploader < PredictionUploader
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions
  plugin :upload_options, cache: { acl: "public-read" }

  process(:store) do |io, context|
    original = io.download
    cropped = resize_to_fill!(original, 720, 720, gravity: "east")
    {original: io, cropped: cropped}
  end
end
