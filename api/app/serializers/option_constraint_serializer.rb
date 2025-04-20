class OptionConstraintSerializer < ActiveModel::Serializer
  attributes :id, :constraint_type, :target_option_id, :target_option

  def target_option
    PartOptionSerializer.new(object.target_option, scope: scope, root: false)
  end
end
