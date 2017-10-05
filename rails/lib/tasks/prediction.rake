namespace :prediction do
  desc "Save an image from shakecam and make an ml prediction against it"
  task :shakecam => :environment do
    prediction = Prediction::Shakecam.predict!
    puts prediction
    ActionCable.server.broadcast("admin_shakecams", prediction: prediction.to_param)
  end

  desc "Pull the mall dataset and generate predictions"
  task :mall => :environment do
    2000.downto(1) do |n|
      url = "https://dimroc-public.s3.amazonaws.com/mall/seq_#{n.to_s.rjust(6, "0")}.jpg"
      puts "Generating prediction from #{url}"
      safe_prediction(url)
    end
  end

  private

  def safe_prediction(url)
    Prediction::Mall.predict!(url)
  rescue Google::Apis::ServerError => e
    puts "Retrying because of #{e}"
    retry
  end
end
