require 'rails_helper'

RSpec.describe Assignment, type: :model do
  it { should validate_presence_of :text }

  it { should validate_presence_of :user_id }

  it { should belong_to :course }

  it { should callback(:add_user_assignment_link).after(:create) }

  context 'when course and user exist' do
    let(:user) { Fabricate :user }

    let(:course) { Fabricate :course, user_id: user.id }

    describe 'add_user_assignment_link' do
      it 'should create User-Assignment association' do
        assignment = Fabricate :assignment, course_id: course.id, user_id: user.id
        expect(AssignmentUser.where(assignment_id: assignment.id, user_id: user.id)).to exist
      end
    end
  end
end
