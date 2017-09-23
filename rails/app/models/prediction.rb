class Prediction < ApplicationRecord
  has_one_attached :snapshot
  has_one_attached :density_map
end
