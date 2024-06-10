# frozen_string_literal: true

FactoryBot.define do
  factory :tutor do
    name { Faker::Name.name }
    course
  end
end
