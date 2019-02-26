class SolutionSerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :assignment
end
