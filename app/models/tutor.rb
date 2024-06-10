# frozen_string_literal: true

class Tutor < ApplicationRecord
  validates :name, presence: true
  belongs_to :course
end
