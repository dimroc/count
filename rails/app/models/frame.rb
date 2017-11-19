class Frame < ApplicationRecord
  has_many :predictions, -> { order(:version) }
  has_many :v2_predictions, -> { where(version: "2") }, class_name: "Prediction"
  scope :v2, -> { joins(:v2_predictions).includes(:v2_predictions) }
  scope :eager, -> { includes(:predictions) }
  scope :asc, -> { order(created_at: :asc) }
  scope :desc, -> { order(created_at: :desc) }

  # The cameras that generate these frames belong in a timezone,
  # which is relevant for retrieveing frames for that particular day.
  def self.timezone
    "Eastern Time (US & Canada)"
  end

  def timezone
    self.class.timezone
  end

  def image
    fail NotImplementedError
  end

  def friendly_type
    self.class.name.demodulize.underscore
  end

  private

  def create_prediction!(reply)
    predictions.create!(density_map: StringIO.new(reply.density_map),
                        version: reply.version,
                        crowd_count: reply.crowd_count,
                        line_count: reply.line_count)
  end
end
