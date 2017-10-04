class Prediction < ApplicationRecord
  include SnapshotUploader[:snapshot]
  include ImageUploader[:density_map]

  scope :desc, -> { order(created_at: :desc) }
end
