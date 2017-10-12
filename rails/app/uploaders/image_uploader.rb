class ImageUploader < Shrine
  plugin :validation_helpers
  plugin :upload_options, store: {
    acl: "publicRead",
    object_options: { cache_control: 'public, max-age: 7200' }
  }

  Attacher.validate do
    validate_max_size 10*1024*1024, message: "is too large (max is 10 MB)"
    validate_mime_type_inclusion ["image/jpeg"]
  end

  def generate_location(io, context)
    name = super
    name = "#{name}.jpg" if File.extname(name).blank?
    [get_type(context), name].join("/")
  end

  private

  def get_type(context)
    record = context[:record]
    if record.respond_to? :friendly_type
      record.friendly_type
    elsif record.respond_to? :type
      record.type
    else
      record.class.name.underscore
    end
  end
end

