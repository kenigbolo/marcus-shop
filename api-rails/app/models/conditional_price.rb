class ConditionalPrice < ApplicationRecord
  belongs_to :option, class_name: 'PartOption'
  belongs_to :context_option, class_name: 'PartOption'

  validates :price_override, presence: true
end

