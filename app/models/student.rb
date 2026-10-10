class Student < ApplicationRecord
  belongs_to :course
  has_many :enrolments, dependent: :restrict_with_error
  has_many :units, through: :enrolments

  validates :student_number, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
end
