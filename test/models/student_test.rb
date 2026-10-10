require "test_helper"

class StudentTest < ActiveSupport::TestCase
  setup do
    @course = Course.create!(code: "TEST-COURSE", name: "Test Course")
    @existing_student = Student.create!(
      student_number: "EXISTING-1001",
      first_name: "Existing",
      last_name: "Student",
      email: "existing.student@example.com",
      course: @course
    )
  end

  test "is valid with all required attributes" do
    student = Student.new(
      student_number: "VALID-1001",
      first_name: "Avery",
      last_name: "Morgan",
      email: "avery.morgan@example.com",
      course: @course
    )

    assert_predicate student, :valid?
  end

  test "requires a student number, names, email, and course" do
    student = Student.new

    assert_not student.valid?
    %i[student_number first_name last_name email course].each do |attribute|
      assert student.errors[attribute].any?, "expected #{attribute} to be required"
    end
  end

  test "requires a unique student number" do
    student = Student.new(
      student_number: @existing_student.student_number,
      first_name: "Avery",
      last_name: "Morgan",
      email: "another.student@example.com",
      course: @course
    )

    assert_not student.valid?
    assert_includes student.errors[:student_number], "has already been taken"
  end

  test "cannot be destroyed while enrolments exist" do
    unit = Unit.create!(code: "TEST-UNIT", name: "Test Unit", credit: 15, course: @course)
    Enrolment.create!(student: @existing_student, unit: unit, semester: "Semester 1", academic_year: 2026)

    assert_no_difference("Student.count") do
      assert_not @existing_student.destroy
    end

    assert @existing_student.errors[:base].any?
    assert Student.exists?(@existing_student.id)
  end
end
