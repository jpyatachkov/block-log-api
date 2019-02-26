class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :text
  has_one :course
end
