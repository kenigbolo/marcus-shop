class ConditionalPrice < ApplicationRecord
  belongs_to :option, class_name: 'PartOption'
  belongs_to :context_option, class_name: 'PartOption'

  validates :price_override, presence: true
  validates :option_id, uniqueness: { scope: :context_option_id }

  validates :context_option_id, uniqueness: {
    scope: :option_id,
    message: "already has a conditional price for this option"
  }
end