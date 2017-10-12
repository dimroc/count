FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "Password123"

    factory :admin do
      admin true
    end
  end
end
