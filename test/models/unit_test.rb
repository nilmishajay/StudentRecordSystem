require "test_helper"

class UnitTest < ActiveSupport::TestCase
  setup do
    @course = Course.create!(code: "COURSE-#{SecureRandom.hex(4)}", name: "Test Course")
  end

  test "requires code, name, positive credits, and a course" do
    unit = Unit.new

    assert_not unit.valid?
    %i[code name credit course].each do |attribute|
      assert unit.errors[attribute].any?, "expected #{attribute} to be required or valid"
    end
  end

  test "rejects zero or negative credits" do
    unit = Unit.new(code: "UNIT-1", name: "Test Unit", credit: 0, course: @course)

    assert_not unit.valid?
    assert unit.errors[:credit].any?
  end

  test "cannot be destroyed while enrolments and results exist" do
    student = Student.create!(
      student_number: "STUDENT-#{SecureRandom.hex(4)}",
      first_name: "Test",
      last_name: "Student",
      email: "student-#{SecureRandom.hex(4)}@example.com",
      course: @course
    )
    unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Test Unit", credit: 15, course: @course)
    enrolment = Enrolment.create!(student: student, unit: unit, semester: "Semester 1", academic_year: 2026)
    result = Result.create!(enrolment: enrolment, mark: 80, grade: "D")

    assert_no_difference("Unit.count") do
      assert_not unit.destroy
    end

    assert Unit.exists?(unit.id)
    assert Result.exists?(result.id)
    assert unit.errors[:base].any?
  end
end
