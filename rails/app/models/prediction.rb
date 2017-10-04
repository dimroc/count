class Prediction < ApplicationRecord
  include SnapshotUploader[:snapshot]
  include PredictionUploader[:density_map]

  scope :desc, -> { order(created_at: :desc) }
end
