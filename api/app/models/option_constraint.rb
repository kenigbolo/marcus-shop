# app/models/option_constraint.rb
# class OptionConstraint < ApplicationRecord
#   belongs_to :part_option
#   belongs_to :related_option, class_name: 'PartOption'

#   # ✅ Fix: provide the correct column name
#   enum constraint_type: { prohibits: 0, requires: 1 }, _prefix: true
# end

class OptionConstraint < ApplicationRecord
  belongs_to :part_option
  belongs_to :related_option, class_name: 'PartOption'

  enum :constraint_type, { prohibits: 0, requires: 1 }
end
