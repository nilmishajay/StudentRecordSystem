class Course < ApplicationRecord
  has_many :students
  has_many :units

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
