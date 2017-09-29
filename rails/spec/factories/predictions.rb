FactoryGirl.define do
  factory :prediction do
    factory :shakecam, class: "Prediction::Shakecam" do
      after(:create) do |prediction|
        img_path = Rails.root.join("spec", "fixtures", "shakeshack-1501021280.jpg")
        prediction.snapshot.attach(
          io: open(img_path),
          filename: "shakecamtest-123.jpg",
          content_type: "image/jpg")
      end
    end
  end
end
