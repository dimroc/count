require 'rails_helper'

RSpec.describe Prediction::Mall, type: :model do
  describe ".fetch!" do
    before { mall_download_succeeds }
    let(:mall_image_url) { "https://dimroc-public.s3.amazonaws.com/mall/seq_001999.jpg" }
    it "uses ml to guess the crowd and line count" do
      prediction = Prediction::Mall.fetch!(mall_image_url)
      expect(prediction.snapshot[:cropped]).to be_present
      expect(prediction.density_map).to be_present
      expect(prediction.crowd_count).to be_between(20, 35)
      expect(prediction.line_count).to be_blank
    end
  end
end
