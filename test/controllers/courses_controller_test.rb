require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = create_course("COURSE-#{SecureRandom.hex(4)}")
    @other_course = create_course("COURSE-#{SecureRandom.hex(4)}")
    @user = User.create!(
      username: "courses-user-#{SecureRandom.hex(4)}",
      email: "courses-user-#{SecureRandom.hex(4)}@example.com",
      password: "secure-password"
    )
  end

  test "authenticated user can view course index, details, and forms" do
    sign_in

    get courses_path
    assert_response :success
    get course_path(@course)
    assert_response :success
    assert_select "h1", text: @course.name
    get new_course_path
    assert_response :success
    get edit_course_path(@course)
    assert_response :success
    assert_select "input[name='course[code]'][value=?]", @course.code
  end

  test "creates a course and shows a success message" do
    sign_in

    assert_difference("Course.count", 1) do
      post courses_path, params: { course: { code: "NEW-COURSE", name: "New Course", description: "Course overview" } }
    end

    course = Course.find_by!(code: "NEW-COURSE")
    assert_redirected_to course_path(course)
    follow_redirect!
    assert_select ".notice", text: /successfully created/
    assert_equal "Course overview", course.description
  end

  test "renders useful errors when creating an invalid or duplicate course" do
    sign_in

    assert_no_difference("Course.count") do
      post courses_path, params: { course: { code: "", name: "" } }
    end
    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Code can't be blank/
    assert_select ".alert-error", text: /Name can't be blank/

    assert_no_difference("Course.count") do
      post courses_path, params: { course: { code: @course.code, name: "Duplicate" } }
    end
    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Code has already been taken/
  end

  test "updates a course" do
    sign_in

    patch course_path(@course), params: { course: { code: "UPDATED-COURSE", name: "Updated Course", description: "Updated" } }

    assert_redirected_to course_path(@course)
    assert_equal "UPDATED-COURSE", @course.reload.code
    assert_equal "Updated Course", @course.name
    assert_equal "Updated", @course.description
  end

  test "deletes an unused course" do
    sign_in

    assert_difference("Course.count", -1) do
      delete course_path(@other_course)
    end

    assert_redirected_to courses_path
    follow_redirect!
    assert_select ".notice", text: /successfully deleted/
  end

  test "preserves courses with dependent students or units" do
    sign_in
    student = Student.create!(
      student_number: "STUDENT-#{SecureRandom.hex(4)}",
      first_name: "Test",
      last_name: "Student",
      email: "student-#{SecureRandom.hex(4)}@example.com",
      course: @course
    )
    unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Test Unit", credit: 15, course: @course)

    assert_no_difference("Course.count") do
      delete course_path(@course)
    end

    assert Course.exists?(@course.id)
    assert Student.exists?(student.id)
    assert Unit.exists?(unit.id)
    assert_redirected_to courses_path
    follow_redirect!
    assert_select ".alert-error", text: /students or units are assigned/
  end

  test "redirects unauthenticated users from every course action" do
    get courses_path
    assert_redirected_to login_path
    get new_course_path
    assert_redirected_to login_path
    get course_path(@course)
    assert_redirected_to login_path
    get edit_course_path(@course)
    assert_redirected_to login_path
    post courses_path, params: { course: { code: "UNAUTH", name: "Unauth" } }
    assert_redirected_to login_path
    patch course_path(@course), params: { course: { name: "Changed" } }
    assert_redirected_to login_path
    delete course_path(@course)
    assert_redirected_to login_path

    assert Course.exists?(@course.id)
    assert_equal "#{@course.code}", @course.reload.code
  end

  private

  def sign_in
    post login_path, params: { username: @user.username, password: "secure-password" }
    assert_redirected_to root_path
  end

  def create_course(code)
    Course.create!(code: code, name: "Test #{code}")
  end
end
