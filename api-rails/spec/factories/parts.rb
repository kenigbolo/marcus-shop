FactoryBot.define do
  factory :part do
    name { Faker::Commerce.material }
    association :product
  end
end
