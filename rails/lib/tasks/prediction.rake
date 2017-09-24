namespace :prediction do
  desc "Save an image from shakecam and make an ml prediction against it"
  task :shakecam => :environment do
    prediction = Prediction::Shakecam.fetch!
    puts "Saved to #{prediction.image.service_url}"
    prediction.predict!
  end

  task :grpc => :environment do
    RPC::Client.new.count_crowd(nil)
  end
end
