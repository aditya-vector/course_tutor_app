class CoursesController < ApplicationController
  def index
    @courses = Course.includes(:tutors).all
    render json: @courses, include: :tutors
  end

  def create
    @service = CourseCreationService.new(course_params:, tutor_params:)
    @service.call

    if @service.errors.present?
      render json: { error: @service.errors }, status: :unprocessable_entity
    else
      render json: @service.course, include: :tutors, status: :created
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :description)
  end

  def tutor_params
    params.require(:course).permit(tutors: [:name])[:tutors]
  end
end
