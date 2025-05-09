class PartOption < ApplicationRecord
  belongs_to :part
  enum :stock_status, { available: 0, out_of_stock: 1 }
  
  has_many :conditional_prices, foreign_key: :option_id, dependent: :destroy
  has_many :source_constraints, class_name: "OptionConstraint", foreign_key: "source_option_id", dependent: :destroy


  validates :name, :base_price, presence: true
  validates :stock_status, inclusion: { in: %w[available out_of_stock] }
  validates :stock_count, numericality: { greater_than_or_equal_to: 0 }
end

