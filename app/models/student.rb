class Student < ApplicationRecord
  belongs_to :course
  has_many :enrolments, dependent: :restrict_with_error
  has_many :units, through: :enrolments

  validates :student_number, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  def wam
    graded_enrolments = enrolments.joins(:result, :unit)
                                  .where(results: { mark: 0..100 }, units: { credit: 1.. })
    total_credits = graded_enrolments.sum("units.credit")
    return if total_credits.zero?

    weighted_marks = graded_enrolments.sum("results.mark * units.credit")
    weighted_marks / BigDecimal(total_credits.to_s)
  end
end
