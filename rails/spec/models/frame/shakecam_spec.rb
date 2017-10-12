require 'rails_helper'

RSpec.describe Frame::Shakecam, type: :model do
  describe ".fetch!" do
    context "reads an empty image" do
      before { shakecam_downloads_empty_image }
      it "uses ml to guess the crowd and line count" do
        expect {
          described_class.predict!
        }.to raise_error ActiveRecord::RecordInvalid
        expect(Frame::Shakecam.count).to eq 0
      end
    end

    context "a proper image" do
      before { shakecam_download_succeeds }
      let(:prediction) { FactoryGirl.create(:shakecam) }
      it "uses ml to guess the crowd and line count" do
        prediction = described_class.predict!
        expect(prediction.snapshot[:cropped]).to be_a ShakecamUploader::UploadedFile
        expect(prediction.density_map).to be_present
        expect(prediction.crowd_count).to be_between(40, 65)
        expect(prediction.line_count).to be_between(20, 45)
      end
    end
  end
end
