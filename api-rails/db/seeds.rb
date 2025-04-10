require 'faker'

puts "🧹 Clearing database..."
CartItemOption.delete_all
CartItem.delete_all
Cart.delete_all
ConditionalPrice.delete_all
OptionConstraint.delete_all
PartOption.delete_all
Part.delete_all
Product.delete_all

puts "🌱 Seeding products..."

20.times do
  product = Product.create!(
    name: "#{Faker::Vehicle.make} #{Faker::Vehicle.model}",
    category: %w[bicycle skateboard roller-skates ski surfboard].sample,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    is_active: [true, true, true, false].sample # most active
  )

  8.times do
    part = product.parts.create!(
      name: Faker::Commerce.material
    )

    6.times do
      option = part.part_options.create!(
        name: Faker::Commerce.color.capitalize,
        base_price: Faker::Commerce.price(range: 10..200),
        stock_status: PartOption.stock_statuses.keys.sample
      )

      # Optional: Add constraints randomly
      if [true, false].sample
        target_option = PartOption.order('RANDOM()').first
        next if target_option == option

        OptionConstraint.create!(
          part_option: option,
          constraint_type: %w[prohibits requires].sample,
          related_option: target_option
        )
      end
    end
  end
end

puts "🛒 Creating sample carts..."

10.times do
  user_id = Faker::Internet.uuid
  cart = Cart.create!(user_id: user_id)

  # Pick a product with parts and options
  product = Product.joins(parts: :part_options).distinct.sample
  next unless product

  selected_options = product.parts.map do |part|
    part.part_options.available.sample || part.part_options.sample
  end.compact

  cart_item = cart.cart_items.create!(
    product: product,
    quantity: rand(1..3)
  )

  selected_options.each do |option|
    cart_item.cart_item_options.create!(
      part_option: option,
      price_applied: option.base_price
    )
  end
end

puts "✅ Seed complete with #{Product.count} products and #{Cart.count} carts!"
