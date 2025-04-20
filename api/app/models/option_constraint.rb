class OptionConstraint < ApplicationRecord
  belongs_to :source_option, class_name: 'PartOption'
  belongs_to :target_option, class_name: 'PartOption'

  enum :constraint_type, { prohibits: 0, requires: 1 }

  validates :constraint_type, presence: true
  validates :source_option_id, uniqueness: { scope: [:target_option_id, :constraint_type] }
end
