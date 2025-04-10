class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity

  belongs_to :product
  has_many :cart_item_options

  class ProductSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
