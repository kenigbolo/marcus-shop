FactoryBot.define do
  factory :product do
    name { Faker::Vehicle.make_and_model }
    category { 'bicycle' }
    description { Faker::Lorem.paragraph }
    is_active { true }

    trait :with_parts_and_options do
      after(:create) do |product|
        2.times do
          part = create(:part, product: product)

          2.times do
            create(:part_option, part: part)
          end
        end
      end
    end
  end
end
