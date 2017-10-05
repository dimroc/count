namespace :prediction do
  desc "Save an image from shakecam and make an ml prediction against it"
  task :shakecam => :environment do
    prediction = Prediction::Shakecam.predict!
    puts prediction
    ActionCable.server.broadcast("admin_shakecams", prediction: prediction.to_param)
  end

  desc "Pull the mall dataset and generate predictions"
  task :mall => :environment do
    (1..2000).each do |n|
      url = "https://dimroc-public.s3.amazonaws.com/mall/seq_#{n.to_s.rjust(6, "0")}.jpg"
      puts "Generating prediction from #{url}"
      safe_prediction(url)
    end
  end

  private

  def safe_prediction(url)
    Prediction::Mall.predict!(url)
  rescue Google::Apis::ServerError, OpenURI::HTTPError => e
    puts "Retrying #{url} because of #{e}"
    sleep 1
    begin
      Prediction::Mall.predict!(url)
    rescue Google::Apis::ServerError, OpenURI::HTTPError, StandardError => e
      puts "Failed again with #{url} because #{e}. Skipping."
    end
  end
end
