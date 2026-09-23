class Enrolment < ApplicationRecord
  belongs_to :student
  belongs_to :unit
  has_one :result

  validates :semester, presence: true
  validates :academic_year, presence: true
end
