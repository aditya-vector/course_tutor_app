# frozen_string_literal: true

class CreateTutors < ActiveRecord::Migration[7.1]
  def change
    create_table :tutors do |t|
      t.string :name, null: false, index: { unique: true }
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
