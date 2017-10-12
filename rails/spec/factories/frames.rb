FactoryGirl.define do
  factory :frame do
    factory :shakecam, class: "Frame::Shakecam" do
      raw { File.open(Rails.root.join("spec", "fixtures", "shakeshack-1501021280.jpg")) }
    end

    factory :mall, class: "Frame::Mall" do
      raw { File.open(Rails.root.join("spec", "fixtures", "mall_000001.jpg")) }
    end
  end
end
