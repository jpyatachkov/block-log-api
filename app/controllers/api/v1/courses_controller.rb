module Api
  module V1
    class CoursesController < ApplicationController
      before_action :set_course, only: %i[show update destroy]

      # GET /courses
      def index
        @courses = Course.all
        render json: @courses
      end

      # GET /courses/1
      def show
        render json: @course
      end

      # POST /courses
      def create
        @course = Course.new(course_params)

        if @course.save
          render json: @course, status: :created, location: api_v1_course_url(@course)
        else
          render json: { errors: @course.errors }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /courses/1
      def update
        if @course.update(course_params)
          render json: @course
        else
          render json: { errors: @course.errors }, status: :bad_request
        end
      end

      # DELETE /courses/1
      def destroy
        @course.destroy
      end

      private

      def set_course
        @course = Course.find(params[:id])
      end

      def course_params
        params.require(:course).permit(:title, :description)
      end
    end
  end
end