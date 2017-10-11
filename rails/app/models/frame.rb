class Frame < ApplicationRecord
  has_many :predictions, -> { order(:version) }
  scope :eager, -> { includes(:predictions) }
  scope :desc, -> { order(created_at: :desc) }

  def image
    fail NotImplementedError
  end

  def friendly_type
    self.class.name.demodulize.underscore
  end
end
