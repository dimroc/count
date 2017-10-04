require 'shrine'
require 'shrine/storage/google_cloud_storage'

bucket = "#{Rails.application.class.parent_name.underscore}_#{Rails.env.underscore}"
Shrine.storages = {
  cache: Shrine::Storage::GoogleCloudStorage.new(bucket: "#{bucket}_cache"),
  store: Shrine::Storage::GoogleCloudStorage.new(bucket: bucket, prefix: 'uploads'),
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :logging
Shrine.plugin :determine_mime_type
