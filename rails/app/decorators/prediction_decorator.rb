class PredictionDecorator < ApplicationDecorator
  delegate_all

  def snapshot_url
    service = snapshot.service
    service.client.signed_url service.bucket.id, snapshot.key
  end
end
