class CartItemOptionSerializer < ActiveModel::Serializer
  attributes :id, :price_applied

  belongs_to :part_option

  class PartOptionSerializer < ActiveModel::Serializer
    attributes :id, :name

    belongs_to :part

    class PartSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
