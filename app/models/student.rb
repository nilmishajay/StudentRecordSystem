class Student < ApplicationRecord
  belongs_to :course
  has_many :enrolments
  has_many :units, through: :enrolments

  validates :student_number, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
end
