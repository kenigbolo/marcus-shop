class Product < ApplicationRecord
  has_many :parts, dependent: :destroy
  has_many :part_options, through: :parts

  validates :name, :category, presence: true
end

