# frozen_string_literal: true

class CourseCreationService
  attr_reader :course_params, :tutor_params, :errors, :course

  def initialize(course_params:, tutor_params: nil)
    @course_params = course_params
    @tutor_params = tutor_params
  end

  def call
    ActiveRecord::Base.transaction do
      @course = Course.create!(course_params)
      create_tutors(@course) if tutor_params.present?
      @course
    end
  rescue ActiveRecord::RecordInvalid => e
    @errors = "#{e.record.class.name} - #{e.record.errors.full_messages.join(', ')}"
  end

  private

  def create_tutors(course)
    tutor_params.each do |tutor_data|
      course.tutors.create!(tutor_data)
    end
  end
end
