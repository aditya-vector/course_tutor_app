# frozen_strng_literal: true

require "rails_helper"

RSpec.describe CourseCreationService, type: :service do
  let(:course_params) { { name: Faker::Educator.course_name, description: Faker::Lorem.paragraph } }
  let(:tutor_params) { [{ name: Faker::Name.name }, { name: Faker::Name.name }] }

  describe "#initialize" do
    subject { described_class.new(course_params:, tutor_params:) }

    it "assigns course_params" do
      expect(subject.course_params).to eq(course_params)
      expect(subject.tutor_params).to eq(tutor_params)
      expect(subject.errors).to be_nil
      expect(subject.course).to be_nil
    end
  end

  describe "#call" do
    subject { described_class.new(course_params:, tutor_params:) }

    context "with valid course params" do
      let(:tutor_params) { nil }

      it "creates a course" do
        expect { subject.call }.to change { Course.count }.by(1).and change { Tutor.count }.by(0)
        expect(subject.errors).to be_nil
      end

      it "returns the created course" do
        subject.call
        expect(subject.course).to eq(Course.last)
        expect(subject.errors).to be_nil
      end
    end

    context "with valid course and tutor params" do
      it "creates a course with tutors" do
        expect { subject.call }.to change { Course.count }.by(1).and change { Tutor.count }.by(2)
        expect(subject.errors).to be_nil
      end

      it "returns the created course and associated tutors" do
        subject.call
        expect(subject.course).to eq(Course.last)
        expect(subject.course.tutors).to eq(Course.last.tutors)
        expect(subject.errors).to be_nil
      end
    end

    context "with invalid course params" do
      let(:course_params) { { name: "" } }

      it "does not create a course" do
        expect { subject.call }.not_to change { Course.count }
        expect(subject.errors).to eq("Course - Name can't be blank")
      end

      it "returns a course with errors" do
        subject.call
        expect(subject.errors).to eq("Course - Name can't be blank")
      end
    end

    context "with invalid tutor params" do
      let(:tutor_params) { [{ name: "" }] }

      it "does not create a course" do
        expect { subject.call }.to change { Course.count }.by(0).and change { Tutor.count }.by(0)
      end

      it "returns a course with errors" do
        subject.call
        expect(subject.errors).to eq("Tutor - Name can't be blank")
      end
    end
  end
end
