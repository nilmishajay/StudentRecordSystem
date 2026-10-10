require "test_helper"

class CourseTest < ActiveSupport::TestCase
  setup do
    @course = Course.create!(code: "COURSE-#{SecureRandom.hex(4)}", name: "Test Course")
  end

  test "requires a code and name" do
    course = Course.new

    assert_not course.valid?
    assert course.errors[:code].any?
    assert course.errors[:name].any?
  end

  test "requires a unique course code" do
    duplicate = Course.new(code: @course.code, name: "Another Course")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:code], "has already been taken"
  end

  test "cannot be destroyed while students or units are associated" do
    student = Student.create!(
      student_number: "STUDENT-#{SecureRandom.hex(4)}",
      first_name: "Test",
      last_name: "Student",
      email: "student-#{SecureRandom.hex(4)}@example.com",
      course: @course
    )

    assert_no_difference("Course.count") do
      assert_not @course.destroy
    end

    assert Course.exists?(@course.id)
    assert Student.exists?(student.id)
    assert @course.errors[:base].any?
  end
end
