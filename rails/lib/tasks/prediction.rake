namespace :prediction do
  desc "Save an image from shakecam and make an ml prediction against it"
  task :shakecam => :environment do
    begin
      prediction = Prediction::Shakecam.fetch!
      puts "Saved snapshot to #{prediction.snapshot[:cropped].url}"
      prediction.predict!
      puts "Density at #{prediction.density_map.url}"
      puts prediction
      ActionCable.server.broadcast("admin_shakecams", prediction: prediction.to_param)
    rescue StandardError, RuntimeError
      prediction.destroy if prediction.present? and !prediction.destroyed?
      raise
    end
  end
end
