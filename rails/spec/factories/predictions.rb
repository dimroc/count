FactoryGirl.define do
  factory :prediction do
    factory :shakecam, class: "Prediction::Shakecam" do
      snapshot { File.open(Rails.root.join("spec", "fixtures", "shakeshack-1501021280.jpg")) }
    end

    factory :mall, class: "Prediction::Mall" do
      snapshot { File.open(Rails.root.join("spec", "fixtures", "mall_000001.jpg")) }
    end
  end
end
