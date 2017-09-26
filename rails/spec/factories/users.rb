FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password123"

    factory :admin do
      admin true
    end
  end
end
