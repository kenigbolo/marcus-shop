class PartOptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :base_price, :stock_status, :stock_count

  has_many :option_constraints
  has_many :conditional_prices
end
