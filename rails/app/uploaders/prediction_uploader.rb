class PredictionUploader < Shrine
  plugin :validation_helpers

  Attacher.validate do
    validate_max_size 10*1024*1024, message: "is too large (max is 10 MB)"
    validate_mime_type_inclusion ["image/jpeg"]
  end

  def generate_location(io, context)
    name = super
    name = "#{name}.jpg" if File.extname(name).blank?
    [ 'predictions', friendly_type(context[:record]), name ].join("/")
  end

  private

  def friendly_type(record)
    record.class.name.demodulize.underscore
  end
end

