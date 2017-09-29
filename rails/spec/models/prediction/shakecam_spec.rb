require 'rails_helper'

RSpec.describe Prediction::Shakecam, type: :model do
  describe "#predict!" do
    let(:prediction) { FactoryGirl.create(:shakecam) }
    it "uses ml to guess the crowd and line count" do
      expect(prediction.density_map).to_not be_attached
      expect(prediction.crowd_count).to be_blank
      expect(prediction.line_count).to be_blank
      prediction.predict!
      expect(prediction.reload.density_map).to be_attached
      expect(prediction.crowd_count).to be_between(40, 65)
      expect(prediction.line_count).to be_between(20, 45)
    end
  end
end
