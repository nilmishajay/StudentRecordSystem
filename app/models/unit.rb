class Unit < ApplicationRecord
  belongs_to :course
  has_many :enrolments, dependent: :restrict_with_error
  has_many :students, through: :enrolments

  validates :code, presence: true
  validates :name, presence: true
  validates :credit, presence: true, numericality: { greater_than: 0 }
end
