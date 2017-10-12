require 'rails_helper'

RSpec.describe Frame::Mall, type: :model do
  describe ".fetch!" do
    before { mall_download_succeeds }
    let(:mall_image_url) { "https://dimroc-public.s3.amazonaws.com/mall/seq_001999.jpg" }
    it "uses ml to guess the crowd and line count" do
      frame = Frame::Mall.predict!(mall_image_url)
      expect(frame.image).to be_present
      expect(frame.raw).to be_a ImageUploader::UploadedFile

      prediction = frame.predictions[0]
      expect(prediction.density_map).to be_present
      expect(prediction.crowd_count).to be_between(20, 35)
      expect(prediction.line_count).to be_zero

      prediction = frame.predictions[1]
      expect(prediction.density_map).to be_present
      expect(prediction.crowd_count).to be_between(20, 35)
      expect(prediction.line_count).to be_zero
    end
  end
end
