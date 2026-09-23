class Result < ApplicationRecord
  belongs_to :enrolment

  validates :mark, presence: true,
                   numericality: { greater_than_or_equal_to: 0,
                                   less_than_or_equal_to: 100 }
  validates :grade, presence: true
end
