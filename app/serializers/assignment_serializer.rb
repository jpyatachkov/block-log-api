class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :text, :tests
  has_one :course
end
