class CartItemOptionSerializer < ActiveModel::Serializer
  attributes :id, :price_applied

  belongs_to :part_option

  class PartOptionSerializer < ActiveModel::Serializer
    attributes :id, :name, :base_price
  end
end

