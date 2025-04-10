class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :category, :description, :is_active

  has_many :parts
end

