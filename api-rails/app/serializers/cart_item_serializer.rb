class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product_id

  has_many :cart_item_options
end
