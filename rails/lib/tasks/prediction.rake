namespace :prediction do
  desc "Save an image from shakecam and make an ml prediction against it"
  task :shakecam => :environment do
    begin
      prediction = Prediction::Shakecam.fetch!
      puts "Saved snapshot to #{prediction.image.service_url}"
      prediction.predict!
      puts "Density at #{prediction.density_map.service_url}"
      puts prediction
      ActionCable.server.broadcast("admin_predictions", prediction: prediction.to_param)
    rescue StandardError
      prediction.destroy if prediction.present? and !prediction.destroyed?
      raise
    end
  end
end
