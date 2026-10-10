require "test_helper"

class EnrolmentTest < ActiveSupport::TestCase
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
  end

  test "is valid with a student, unit, semester, and positive academic year" do
    enrolment = Enrolment.new(student: @student, unit: @unit, semester: "Semester 1", academic_year: 2026)

    assert_predicate enrolment, :valid?
  end

  test "requires existing student and unit plus semester and positive integer year" do
    enrolment = Enrolment.new(semester: "", academic_year: 0)

    assert_not enrolment.valid?
    %i[student unit semester academic_year].each do |attribute|
      assert enrolment.errors[attribute].any?, "expected #{attribute} to be invalid"
    end
  end

  test "prevents duplicate enrolment for the same student unit and term" do
    Enrolment.create!(student: @student, unit: @unit, semester: "Semester 1", academic_year: 2026)
    duplicate = Enrolment.new(student: @student, unit: @unit, semester: "Semester 1", academic_year: 2026)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:unit_id], "is already enrolled for this student, semester, and academic year"
  end

  test "allows the same unit in a different semester or year" do
    Enrolment.create!(student: @student, unit: @unit, semester: "Semester 1", academic_year: 2026)

    different_term = Enrolment.new(student: @student, unit: @unit, semester: "Semester 2", academic_year: 2026)
    different_year = Enrolment.new(student: @student, unit: @unit, semester: "Semester 1", academic_year: 2027)

    assert_predicate different_term, :valid?
    assert_predicate different_year, :valid?
  end

  test "cannot be destroyed while a result exists" do
    enrolment = Enrolment.create!(student: @student, unit: @unit, semester: "Semester 1", academic_year: 2026)
    result = Result.create!(enrolment: enrolment, mark: 85, grade: "HD")

    assert_no_difference("Enrolment.count") do
      assert_not enrolment.destroy
    end

    assert Enrolment.exists?(enrolment.id)
    assert Result.exists?(result.id)
    assert enrolment.errors[:base].any?
  end
end
