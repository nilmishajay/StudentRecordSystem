class Enrolment < ApplicationRecord
  belongs_to :student
  belongs_to :unit
  has_one :result, dependent: :restrict_with_error

  validates :semester, presence: true
  validates :academic_year, presence: true,
                            numericality: { only_integer: true, greater_than: 0 }
  validates :unit_id, uniqueness: {
    scope: %i[student_id semester academic_year],
    message: "is already enrolled for this student, semester, and academic year"
  }
end
