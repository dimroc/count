namespace :prediction do
  desc "Save an image from shakecam and make an ml prediction against it"
  task :shakecam => :environment do
    prediction = with_retry { Prediction::Shakecam.predict! }
    if prediction.present?
      puts prediction
      ActionCable.server.broadcast("admin_shakecams", prediction: prediction.to_param)
    end
  end

  desc "Pull the mall dataset and generate predictions"
  task :mall => :environment do
    (1..2000).each do |n|
      url = "https://dimroc-public.s3.amazonaws.com/mall/seq_#{n.to_s.rjust(6, "0")}.jpg"
      puts "Generating prediction from #{url}"
      with_retry { Prediction::Mall.predict!(url) }
    end
  end

  private

  # Not happy about having to retry but GCS returns a lot of 5xx internal errors.
  def with_retry
    yield
  rescue Google::Apis::ServerError, OpenURI::HTTPError => e
    puts "Retrying because of #{e}"
    sleep 1
    begin
      yield
    rescue Google::Apis::ServerError, OpenURI::HTTPError, StandardError => e
      puts "Failed again because #{e}. Skipping."
    end
  end
end
