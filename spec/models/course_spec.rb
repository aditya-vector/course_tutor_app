# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validations' do
    subject { FactoryBot.build(:course) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should have_many(:tutors) }
  end
end
