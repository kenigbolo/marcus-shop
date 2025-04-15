class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  has_many :cart_item_options, dependent: :destroy

  validates :quantity, numericality: { greater_than: 0 }
end
