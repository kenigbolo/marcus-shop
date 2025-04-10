# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data
CartItemOption.delete_all
CartItem.delete_all
Cart.delete_all
ConditionalPrice.delete_all
OptionConstraint.delete_all
PartOption.delete_all
Part.delete_all
Product.delete_all

puts "🌱 Seeding..."

# Create product
bike = Product.create!(
  name: "Custom Bicycle",
  category: "bicycle",
  description: "Fully customizable bike built for your style and needs.",
  is_active: true
)

# Create parts
frame = bike.parts.create!(name: "Frame")
finish = bike.parts.create!(name: "Frame Finish")
wheels = bike.parts.create!(name: "Wheels")
rim = bike.parts.create!(name: "Rim Color")
chain = bike.parts.create!(name: "Chain")

# Frame options
full_suspension = frame.part_options.create!(name: "Full-suspension", base_price: 130, stock_status: :available)
diamond = frame.part_options.create!(name: "Diamond", base_price: 110, stock_status: :available)
step_through = frame.part_options.create!(name: "Step-through", base_price: 100, stock_status: :available)

# Finish options
matte = finish.part_options.create!(name: "Matte", base_price: 20, stock_status: :available)
shiny = finish.part_options.create!(name: "Shiny", base_price: 30, stock_status: :available)

# Wheels options
road = wheels.part_options.create!(name: "Road wheels", base_price: 80, stock_status: :available)
mountain = wheels.part_options.create!(name: "Mountain wheels", base_price: 100, stock_status: :available)
fat_bike = wheels.part_options.create!(name: "Fat bike wheels", base_price: 120, stock_status: :available)

# Rim color options
red_rim = rim.part_options.create!(name: "Red", base_price: 15, stock_status: :available)
black_rim = rim.part_options.create!(name: "Black", base_price: 10, stock_status: :available)
blue_rim = rim.part_options.create!(name: "Blue", base_price: 20, stock_status: :available)

# Chain options
single_speed = chain.part_options.create!(name: "Single-speed chain", base_price: 43, stock_status: :available)
eight_speed = chain.part_options.create!(name: "8-speed chain", base_price: 60, stock_status: :available)

# Constraints
# Mountain wheels require Full-suspension frame
OptionConstraint.create!(
  part_option: mountain,
  constraint_type: :requires,
  related_option: full_suspension
)

# Fat bike wheels prohibit red rim color
OptionConstraint.create!(
  part_option: fat_bike,
  constraint_type: :prohibits,
  related_option: red_rim
)

# Conditional pricing for matte finish depending on frame
ConditionalPrice.create!(
  option: matte,
  context_option: full_suspension,
  price_override: 50
)

ConditionalPrice.create!(
  option: matte,
  context_option: diamond,
  price_override: 35
)

puts "✅ Seeding complete!"

puts "🛒 Creating sample cart..."

# Sample cart for a user
cart = Cart.create!(user_id: SecureRandom.uuid)

# Select options for a configured bike
selected_options = [
  full_suspension,   # Frame
  shiny,             # Finish
  road,              # Wheels
  blue_rim,          # Rim
  single_speed       # Chain
]

# Create the cart item
cart_item = cart.cart_items.create!(
  product: bike,
  quantity: 1
)

# Add selected options to cart item
selected_options.each do |option|
  # Apply conditional price if one exists
  conditional = option.conditional_prices.find do |cp|
    selected_options.include?(cp.context_option)
  end

  price = conditional&.price_override || option.base_price

  cart_item.cart_item_options.create!(
    part_option: option,
    price_applied: price
  )
end

puts "✅ Sample cart created!"
