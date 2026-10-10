class Course < ApplicationRecord
  has_many :students, dependent: :restrict_with_error
  has_many :units, dependent: :restrict_with_error

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
