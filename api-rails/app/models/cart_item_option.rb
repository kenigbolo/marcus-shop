class CartItemOption < ApplicationRecord
  belongs_to :cart_item
  belongs_to :part_option

  validates :price_applied, presence: true
end

