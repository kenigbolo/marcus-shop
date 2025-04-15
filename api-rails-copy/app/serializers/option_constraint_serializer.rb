class OptionConstraintSerializer < ActiveModel::Serializer
  attributes :id, :constraint_type, :related_option_id
end
