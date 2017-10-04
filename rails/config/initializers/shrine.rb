require 'shrine'
require 'shrine/storage/google_cloud_storage'

bucket = Rails.application.secrets.google_cloud_project.underscore
Shrine.storages = {
  cache: Shrine::Storage::GoogleCloudStorage.new(bucket: "#{bucket}_cache"),
  store: Shrine::Storage::GoogleCloudStorage.new(bucket: bucket, prefix: 'uploads'),
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :logging
Shrine.plugin :determine_mime_type
