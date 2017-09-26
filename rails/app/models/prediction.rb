class Prediction < ApplicationRecord
  has_one_attached :snapshot
  has_one_attached :density_map

  scope :desc, -> { order(created_at: :desc) }
  scope :eager, -> { with_attached_snapshot.with_attached_density_map }

  def image
    snapshot
  end
end
