class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :description, :is_active

  has_many :parts

  class PartSerializer < ActiveModel::Serializer
    attributes :id, :name

    has_many :part_options

    class PartOptionSerializer < ActiveModel::Serializer
      attributes :id, :name, :base_price, :stock_status, :stock_count
    end
  end
end
