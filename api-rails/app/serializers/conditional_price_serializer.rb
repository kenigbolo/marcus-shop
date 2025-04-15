class ConditionalPriceSerializer < ActiveModel::Serializer
  attributes :id, :context_option_id, :price_override
end
