class Unit < ApplicationRecord
  belongs_to :course
  has_many :enrolements
  has_many :students, through: :enrolements

  validates :code, presence: true
  validates :name, presence: true
  validates :credit, presence: true, numericality: { greater_than: 0 }
end
