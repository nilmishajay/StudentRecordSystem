require "test_helper"

class UnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = create_course("COURSE-#{SecureRandom.hex(4)}")
    @other_course = create_course("COURSE-#{SecureRandom.hex(4)}")
    @unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Test Unit", credit: 15, course: @course)
    @user = User.create!(
      username: "units-user-#{SecureRandom.hex(4)}",
      email: "units-user-#{SecureRandom.hex(4)}@example.com",
      password: "secure-password"
    )
  end

  test "authenticated user can view unit index, details, and forms" do
    sign_in

    get units_path
    assert_response :success
    get unit_path(@unit)
    assert_response :success
    assert_select "a[href=?]", course_path(@course), text: @course.name
    get new_unit_path
    assert_response :success
    get edit_unit_path(@unit)
    assert_response :success
    assert_select "input[name='unit[code]'][value=?]", @unit.code
  end

  test "creates a unit linked to a course and shows a success message" do
    sign_in

    assert_difference("Unit.count", 1) do
      post units_path, params: { unit: { code: "NEW-UNIT", name: "New Unit", credit: 10, course_id: @course.id } }
    end

    unit = Unit.find_by!(code: "NEW-UNIT")
    assert_redirected_to unit_path(unit)
    follow_redirect!
    assert_select ".notice", text: /successfully created/
    assert_equal @course, unit.course
  end

  test "renders useful errors for missing attributes, invalid credits, or course" do
    sign_in

    assert_no_difference("Unit.count") do
      post units_path, params: { unit: { code: "", name: "", credit: 0, course_id: "" } }
    end
    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Code can't be blank/
    assert_select ".alert-error", text: /Name can't be blank/
    assert_select ".alert-error", text: /Credit must be greater than 0/

    assert_no_difference("Unit.count") do
      post units_path, params: { unit: { code: "NO-COURSE", name: "No Course", credit: 15, course_id: "" } }
    end
    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Course must exist/
  end

  test "updates unit details and assigned course" do
    sign_in

    patch unit_path(@unit), params: { unit: { code: "UPDATED-UNIT", name: "Updated Unit", credit: 20, course_id: @other_course.id } }

    assert_redirected_to unit_path(@unit)
    assert_equal "UPDATED-UNIT", @unit.reload.code
    assert_equal "Updated Unit", @unit.name
    assert_equal 20, @unit.credit
    assert_equal @other_course, @unit.course
  end

  test "deletes a unit without enrolments" do
    sign_in

    assert_difference("Unit.count", -1) do
      delete unit_path(@unit)
    end

    assert_redirected_to units_path
    follow_redirect!
    assert_select ".notice", text: /successfully deleted/
  end

  test "preserves units with enrolled students and result history" do
    sign_in
    student = Student.create!(
      student_number: "STUDENT-#{SecureRandom.hex(4)}",
      first_name: "Test",
      last_name: "Student",
      email: "student-#{SecureRandom.hex(4)}@example.com",
      course: @course
    )
    enrolment = Enrolment.create!(student: student, unit: @unit, semester: "Semester 1", academic_year: 2026)
    result = Result.create!(enrolment: enrolment, mark: 85, grade: "HD")

    assert_no_difference("Unit.count") do
      delete unit_path(@unit)
    end

    assert Unit.exists?(@unit.id)
    assert Enrolment.exists?(enrolment.id)
    assert Result.exists?(result.id)
    assert_redirected_to units_path
    follow_redirect!
    assert_select ".alert-error", text: /enrolments or academic results/
  end

  test "redirects unauthenticated users from every unit action" do
    get units_path
    assert_redirected_to login_path
    get new_unit_path
    assert_redirected_to login_path
    get unit_path(@unit)
    assert_redirected_to login_path
    get edit_unit_path(@unit)
    assert_redirected_to login_path
    post units_path, params: { unit: { code: "UNAUTH", name: "Unauth", credit: 15, course_id: @course.id } }
    assert_redirected_to login_path
    patch unit_path(@unit), params: { unit: { name: "Changed" } }
    assert_redirected_to login_path
    delete unit_path(@unit)
    assert_redirected_to login_path

    assert Unit.exists?(@unit.id)
    assert_equal "Test Unit", @unit.reload.name
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
