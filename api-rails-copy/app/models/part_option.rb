class PartOption < ApplicationRecord
  belongs_to :part
  enum :stock_status, { available: 0, out_of_stock: 1 }

  has_many :option_constraints, dependent: :destroy
  has_many :conditional_prices, foreign_key: :option_id, dependent: :destroy

  validates :name, :base_price, presence: true
  validates :stock_status, inclusion: { in: %w[available out_of_stock] }
end

