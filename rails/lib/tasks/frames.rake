namespace :frames do
  desc "Pull down images retrieved from the shake cam for DATE=2017-10-12"
  task :shakecam => :environment do
    date_param = ENV["DATE"] || "2017-10-12"
    date = Date.parse(date_param)
    folder = "tmp/frames/#{date_param}"
    FileUtils.mkdir_p folder
    Frame::Shakecam.v2.asc.day(date).each_with_index do |frame, i|
      dst = "#{folder}/frame_#{"%03d" % i}.jpg"
      puts "#{i}: #{frame.image.url} to #{dst}"
      download = open(frame.image.url)
      IO.copy_stream(download, dst)
    end
  end
end

