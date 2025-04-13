FactoryBot.define do
  factory :part_option do
    name { Faker::Commerce.color.capitalize }
    base_price { Faker::Commerce.price(range: 10..100) }
    stock_status { 'available' }
    association :part
  end
end
