class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :text, :tests
  has_one :course

  def tests
    # wtf ???
    # it doesnt accpet :inputs
    object.tests.slice('inputs')
  end
end
