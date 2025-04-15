class PartSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :part_options
end
