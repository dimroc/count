class PredictionUploader < Shrine
  plugin :validation_helpers

  Attacher.validate do
    validate_max_size 10*1024*1024, message: "is too large (max is 10 MB)"
    validate_mime_type_inclusion ["image/jpeg"]
  end

  def generate_location(io, context)
    [ 'predictions', "#{super}.jpg" ].join("/")
  end
end

