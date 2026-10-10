require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course_one = create_course("COURSE-ONE")
    @course_two = create_course("COURSE-TWO")
    @student = create_student(course: @course_one)
    @user = User.create!(
      username: "students-test-#{SecureRandom.hex(8)}",
      email: "students-test-#{SecureRandom.hex(8)}@example.com",
      password: "secure-password"
    )
  end

  test "authenticated user can view the student index" do
    sign_in

    get students_path
    assert_response :success
  end

  test "authenticated user can view a student and edit form" do
    sign_in
    student = @student

    get student_path(student)
    assert_response :success
    assert_select "h2", text: "#{student.first_name} #{student.last_name}"

    get edit_student_path(student)
    assert_response :success
    assert_select "h1", text: "Edit Student"
    assert_select "input[name='student[student_number]'][value=?]", student.student_number
  end

  test "authenticated user can view the new student form" do
    sign_in

    get new_student_path
    assert_response :success
    assert_select "input[name='student[student_number]']"
  end

  test "creates a student with valid details" do
    sign_in
    attributes = valid_student_params

    assert_difference("Student.count", 1) do
      post students_path, params: { student: attributes }
    end

    student = Student.find_by!(student_number: attributes[:student_number])
    assert_redirected_to student_path(student)
    assert_equal attributes[:student_number], student.student_number
    assert_equal "Avery", student.first_name
    assert_equal @course_one, student.course
  end

  test "renders useful validation errors when creating an invalid student" do
    sign_in

    assert_no_difference("Student.count") do
      post students_path,
           params: { student: { student_number: "", first_name: "", last_name: "", email: "", course_id: "" } }
    end

    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Student number can't be blank/
    assert_select ".alert-error", text: /First name can't be blank/
  end

  test "updates student details and assigned course" do
    sign_in
    student = create_student

    patch student_path(student), params: {
      student: {
        student_number: "UPDATED-#{student.id}",
        first_name: "Jordan",
        last_name: "Taylor",
        email: "jordan.taylor@example.com",
        course_id: @course_two.id
      }
    }

    assert_redirected_to student_path(student)
    assert_equal "UPDATED-#{student.id}", student.reload.student_number
    assert_equal "Jordan", student.first_name
    assert_equal "Taylor", student.last_name
    assert_equal "jordan.taylor@example.com", student.email
    assert_equal @course_two, student.course
  end

  test "renders useful validation errors when updating an invalid student" do
    sign_in
    student = create_student

    patch student_path(student), params: { student: { first_name: "" } }

    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /First name can't be blank/
    assert_equal "Avery", student.reload.first_name
  end

  test "deletes a student without enrolments" do
    sign_in
    student = create_student

    assert_difference("Student.count", -1) do
      delete student_path(student)
    end

    assert_redirected_to students_path
    assert_not Student.exists?(student.id)
  end

  test "does not delete a student with enrolments or academic results" do
    sign_in
    student = @student
    unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Test Unit", credit: 15, course: @course_one)
    enrolment = Enrolment.create!(student: student, unit: unit, semester: "Semester 1", academic_year: 2026)
    result = Result.create!(enrolment: enrolment, mark: 85, grade: "HD")

    assert_no_difference("Student.count") do
      delete student_path(student)
    end

    assert Student.exists?(student.id)
    assert Result.exists?(result.id)
    assert_redirected_to students_path
    follow_redirect!
    assert_select ".alert-error", text: /enrolments or academic results/
  end

  test "redirects unauthenticated users from every student action" do
    student = @student

    get students_path
    assert_redirected_to login_path
    get new_student_path
    assert_redirected_to login_path
    get student_path(student)
    assert_redirected_to login_path
    get edit_student_path(student)
    assert_redirected_to login_path
    post students_path, params: { student: valid_student_params }
    assert_redirected_to login_path
    patch student_path(student), params: { student: { first_name: "Changed" } }
    assert_redirected_to login_path
    delete student_path(student)
    assert_redirected_to login_path

    assert Student.exists?(student.id)
    assert_equal "Avery", student.reload.first_name
  end

  private

  def sign_in
    post login_path, params: { username: @user.username, password: "secure-password" }
    assert_redirected_to root_path
  end

  def valid_student_params
    {
      student_number: "STU-#{SecureRandom.hex(6)}",
      first_name: "Avery",
      last_name: "Morgan",
      email: "avery-#{SecureRandom.hex(6)}@example.com",
      course_id: @course_one.id
    }
  end

  def create_course(code)
    Course.create!(code: code, name: code.tr("-", " ").capitalize)
  end

  def create_student(course: @course_one)
    Student.create!(valid_student_params.merge(course_id: course.id))
  end
end
