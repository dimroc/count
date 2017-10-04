require "image_processing/mini_magick"

class SnapshotUploader < Shrine
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :validation_helpers

  process(:store) do |io, context|
    original = io.download
    cropped = resize_to_fill!(original, 720, 720, gravity: "east")
    {original: io, cropped: cropped}
  end

  Attacher.validate do
    validate_max_size 10*1024*1024, message: "is too large (max is 10 MB)"
    validate_mime_type_inclusion ["image/jpeg", "image/png", "image/gif", "application/pdf"]
  end
end
