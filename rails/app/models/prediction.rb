class Prediction < ApplicationRecord
  include SnapshotUploader[:snapshot]
  include PredictionUploader[:density_map]

  scope :desc, -> { order(created_at: :desc) }

  def to_s
    "Type: #{friendly_type} Version: #{version}, Crowd: #{crowd_count}, Line: #{line_count}"
  end

  def friendly_type
    self.class.name.demodulize.underscore
  end

  private

  def rpcclient
    @rpcclient ||= RPC::Client.default
  end
end
