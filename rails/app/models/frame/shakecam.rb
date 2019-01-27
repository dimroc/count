class Frame::Shakecam < Frame
  include ShakecamUploader[:raw]

  scope :day, -> (day) { where(created_at: working_hours(day)) }
  scope :today, -> { day(DateTime.now) }

  class << self
    def predict!
      url = prescrapeShakeshackdotcom
      raw = open(url)
      Rails.logger.info "Saving shakecam frame #{url}, data present? #{raw.present?}"
      puts "Saving shakecam frame #{url}, data present? #{raw.present?}"
      frame = create!(raw: raw, created_at: DateTime.now)
      frame.predict!(version: 1)
      frame.predict!(version: 2)
      frame
    rescue StandardError, RuntimeError, Google::Apis::ServerError
      frame.destroy if frame.present? and !frame.destroyed?
      raise
    end

    def prescrapeShakeshackdotcom
      url = "https://www.shakeshack.com/location/madison-square-park/"
      page = Nokogiri::HTML(open(url))
      img = page.css("img#shack-cam-image")
      img && img.first && img.first['src']
    end

    def working_hours(day)
      day.in_time_zone(timezone).change(hour: 8, min: 0, sec: 0)..day.in_time_zone(timezone).end_of_day
    end
  end

  def image
    raw[:cropped] if raw.respond_to? :keys
  end

  def closed
    !self.class.working_hours(created_at).cover?(created_at)
  end

  def predict!(version: 2)
    create_prediction! RPC::Client.new(version).count_line(image.read)
  end
end
