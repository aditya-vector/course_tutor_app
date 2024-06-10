# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Courses", type: :request do
  describe "GET /courses" do

    subject { get "/courses" }

    it "returns all courses" do
      FactoryBot.create_list(:course, 2) do |course|
        FactoryBot.create_list(:tutor, 2, course: course)
      end

      subject

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(Course.all.to_json(include: :tutors))
    end
  end

  describe "POST /courses" do
    let (:course_params) {
      {
        name: Faker::Educator.course_name,
        description: Faker::Lorem.paragraph
      }
    }

    let (:tutors_params) { [{ name: Faker::Name.name }, { name: Faker::Name.name }] }

    subject { post "/courses", params: { course: course_params } }

    describe "with valid params" do
      context "without tutors" do
        it "creates a new course" do
          expect { subject }.to change(Course, :count).by(1).and change(Tutor, :count).by(0)
          expect(response).to have_http_status(:created)
          expect(response.body).to eq(Course.last.to_json(include: :tutors))
        end
      end

      context "with tutors" do
        let (:course_params) {
          {
            name: Faker::Educator.course_name,
            description: Faker::Lorem.paragraph,
            tutors: tutors_params,
          }
        }

        it "creates a new course with tutors" do
          expect { subject }.to change(
            Course, :count
          ).by(1).and change(
            Tutor, :count
          ).by(2)
          expect(Course.last.tutors.count).to eq(2)

          expect(response).to have_http_status(:created)
          expect(response.body).to eq(Course.last.to_json(include: :tutors))
        end
      end
    end

    describe "with invalid params" do
      let (:course_params) {
        {
          name: "",
          description: Faker::Lorem.paragraph
        }
      }

      it "returns an error" do
        expect { subject }.to change(Course, :count).by(0).and change(Tutor, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Name can't be blank")
      end

      context "with invalid tutors" do
        let (:course_params) {
          {
            name: Faker::Educator.course_name,
            description: Faker::Lorem.paragraph,
            tutors: [{ name: "" }]
          }
        }

        it "returns an error" do
          expect { subject }.to change(Course, :count).by(0).and change(Tutor, :count).by(0)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Name can't be blank")
        end
      end
    end
  end
end
