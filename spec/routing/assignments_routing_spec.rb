require 'rails_helper'

RSpec.describe Api::V1::AssignmentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/courses/1/assignments').to route_to('api/v1/assignments#index', course_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/courses/1/assignments/1').to route_to('api/v1/assignments#show',
                                                                 course_id: '1',
                                                                 id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/courses/1/assignments').to route_to('api/v1/assignments#create', course_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/courses/1/assignments/1').to route_to('api/v1/assignments#update',
                                                                 course_id: '1',
                                                                 id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/courses/1/assignments/1').to route_to('api/v1/assignments#update',
                                                                   course_id: '1',
                                                                   id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/courses/1/assignments/1').to route_to('api/v1/assignments#destroy',
                                                                    course_id: '1',
                                                                    id: '1')
    end
  end
end
