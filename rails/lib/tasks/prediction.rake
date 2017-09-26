namespace :prediction do
  desc "Save an image from shakecam and make an ml prediction against it"
  task :shakecam => :environment do
    prediction = Prediction::Shakecam.fetch!
    puts "Saved snapshot to #{prediction.image.service_url}"
    prediction.predict!
    puts "Density at #{prediction.density_map.service_url}"
    puts prediction
  end
end
