namespace :prediction do
  desc "Save an image from shakecam and make an ml prediction against it"
  task :shakecam => :environment do
    prediction = Prediction::Shakecam.fetch!
    puts "Saved to #{prediction.decorate.snapshot_url}"
    prediction.predict!
  end
end
