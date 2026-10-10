require "test_helper"

class ResultTest < ActiveSupport::TestCase
  setup do
    @course = Course.create!(code: "COURSE-#{SecureRandom.hex(4)}", name: "Test Course")
    @student = Student.create!(
      student_number: "STUDENT-#{SecureRandom.hex(4)}",
      first_name: "Test",
      last_name: "Student",
      email: "student-#{SecureRandom.hex(4)}@example.com",
      course: @course
    )
    @unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Test Unit", credit: 15, course: @course)
    @enrolment = Enrolment.create!(student: @student, unit: @unit, semester: "Semester 1", academic_year: 2026)
  end

  test "is valid with a recorded enrolment, mark, and explicit grade" do
    result = Result.new(enrolment: @enrolment, mark: 75.5, grade: "D")

    assert_predicate result, :valid?
  end

  test "accepts mark boundaries zero and one hundred" do
    assert_predicate Result.new(enrolment: @enrolment, mark: 0, grade: "Pass"), :valid?
    assert_predicate Result.new(enrolment: @enrolment, mark: 100, grade: "High"), :valid?
  end

  test "requires mark grade and enrolment" do
    result = Result.new

    assert_not result.valid?
    %i[enrolment mark grade].each do |attribute|
      assert result.errors[attribute].any?, "expected #{attribute} to be required"
    end
  end

  test "rejects marks below zero above one hundred and nonnumeric marks" do
    [ -0.01, 100.01, "not a mark" ].each do |mark|
      result = Result.new(enrolment: @enrolment, mark: mark, grade: "Test")

      assert_not result.valid?, "expected #{mark.inspect} to be invalid"
      assert result.errors[:mark].any?
    end
  end

  test "prevents more than one result for an enrolment" do
    Result.create!(enrolment: @enrolment, mark: 70, grade: "D")
    duplicate = Result.new(enrolment: @enrolment, mark: 80, grade: "D")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:enrolment_id], "already has a recorded result"
  end
end
