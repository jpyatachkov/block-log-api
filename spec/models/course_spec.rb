require 'rails_helper'

RSpec.describe Course, type: :model do
  it { should validate_presence_of :title }

  it { should validate_precence_of :short_description }

  it { should validate_presence_of :description }

  it do
    should callback(:set_user_permissions).after(:create)
    should callback(:add_user_course_link).after(:create)
  end

  context 'when course and user exist' do
    let(:user) { Fabricate :user }

    let(:title) { Faker::Lorem.sentence }

    let(:course) { Fabricate :course, title: title, user_id: user.id }

    describe 'by default' do
      it 'should set is_active to true' do
        expect(course.is_active).to be true
      end
    end

    describe 'add_user_course_link' do
      it 'should create User-Course association' do
        expect(CourseUser.where(course_id: course.id,
                                user_id: user.id)).to exist
      end
    end
  end
end
