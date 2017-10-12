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
      it "uses ml to guess the crowd and line count" do
        frame = described_class.predict!
        expect(frame.raw[:cropped]).to be_a ShakecamUploader::UploadedFile

        prediction = frame.predictions[0]
        expect(prediction.density_map).to be_present
        expect(prediction.crowd_count).to be_between(40, 65)
        expect(prediction.line_count).to be_between(20, 45)

        prediction = frame.predictions[1]
        expect(prediction.density_map).to be_present
        expect(prediction.crowd_count).to be_between(40, 65)
        expect(prediction.line_count).to be_between(20, 45)
      end
    end
  end
end
