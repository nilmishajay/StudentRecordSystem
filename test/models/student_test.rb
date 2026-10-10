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

  test "calculates WAM using credits and excludes units without valid results" do
    first_unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "First Unit", credit: 10, course: @course)
    second_unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Second Unit", credit: 30, course: @course)
    ungraded_unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Ungraded Unit", credit: 100, course: @course)

    first_enrolment = Enrolment.create!(student: @existing_student, unit: first_unit, semester: "Semester 1", academic_year: 2026)
    second_enrolment = Enrolment.create!(student: @existing_student, unit: second_unit, semester: "Semester 1", academic_year: 2026)
    Enrolment.create!(student: @existing_student, unit: ungraded_unit, semester: "Semester 2", academic_year: 2026)
    Result.create!(enrolment: first_enrolment, mark: "80.00", grade: "D")
    Result.create!(enrolment: second_enrolment, mark: "70.00", grade: "D")

    assert_equal BigDecimal("72.5"), @existing_student.wam
  end

  test "includes boundary marks of zero and one hundred in WAM" do
    zero_unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Zero Unit", credit: 15, course: @course)
    hundred_unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Hundred Unit", credit: 15, course: @course)
    zero_enrolment = Enrolment.create!(student: @existing_student, unit: zero_unit, semester: "Semester 1", academic_year: 2026)
    hundred_enrolment = Enrolment.create!(student: @existing_student, unit: hundred_unit, semester: "Semester 1", academic_year: 2026)
    Result.create!(enrolment: zero_enrolment, mark: 0, grade: "Pass")
    Result.create!(enrolment: hundred_enrolment, mark: 100, grade: "High")

    assert_equal BigDecimal("50"), @existing_student.wam
  end

  test "returns nil when no valid marks are recorded" do
    assert_nil @existing_student.wam
  end
end
