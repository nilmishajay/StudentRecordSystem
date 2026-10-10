require "test_helper"

class EnrolmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = Course.create!(code: "COURSE-#{SecureRandom.hex(4)}", name: "Test Course")
    @student = Student.create!(
      student_number: "STUDENT-#{SecureRandom.hex(4)}",
      first_name: "Taylor",
      last_name: "Student",
      email: "student-#{SecureRandom.hex(4)}@example.com",
      course: @course
    )
    @unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Test Unit", credit: 15, course: @course)
    @user = User.create!(
      username: "enrolments-user-#{SecureRandom.hex(4)}",
      email: "enrolments-user-#{SecureRandom.hex(4)}@example.com",
      password: "secure-password"
    )
  end

  test "authenticated user can view enrolments and new/details pages" do
    sign_in
    enrolment = create_enrolment

    get enrolments_path
    assert_response :success
    assert_select "a[href=?]", student_path(@student), text: /#{@student.student_number}/

    get new_enrolment_path(student_id: @student.id)
    assert_response :success
    assert_select "select[name='enrolment[student_id]'] option[selected][value=?]", @student.id.to_s

    get enrolment_path(enrolment)
    assert_response :success
    assert_select ".detail-value", text: "Semester 1"
    assert_select ".detail-value", text: "2026"
  end

  test "creates an enrolment and shows term on student academic record" do
    sign_in

    assert_difference("Enrolment.count", 1) do
      post enrolments_path, params: {
        enrolment: {
          student_id: @student.id,
          unit_id: @unit.id,
          semester: "Semester 2",
          academic_year: 2026
        }
      }
    end

    enrolment = Enrolment.find_by!(student: @student, unit: @unit)
    assert_redirected_to student_path(@student)
    follow_redirect!
    assert_select ".notice", text: /successfully enrolled/
    assert_select ".data-table", text: /Semester 2/
    assert_select ".data-table", text: /2026/
    assert_select ".data-table", text: /#{@unit.code}/
    assert_equal enrolment, @student.enrolments.first
  end

  test "renders errors for missing fields or nonexistent student and unit" do
    sign_in

    assert_no_difference("Enrolment.count") do
      post enrolments_path, params: { enrolment: { student_id: "", unit_id: "", semester: "", academic_year: "" } }
    end
    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Student must exist/
    assert_select ".alert-error", text: /Unit must exist/
    assert_select ".alert-error", text: /Semester can't be blank/
    assert_select ".alert-error", text: /Academic year can't be blank/

    assert_no_difference("Enrolment.count") do
      post enrolments_path, params: { enrolment: { student_id: 9_999_999, unit_id: @unit.id, semester: "Semester 1", academic_year: 2026 } }
    end
    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Student must exist/

    assert_no_difference("Enrolment.count") do
      post enrolments_path, params: { enrolment: { student_id: @student.id, unit_id: 9_999_999, semester: "Semester 1", academic_year: 2026 } }
    end
    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Unit must exist/
  end

  test "rejects duplicate student unit enrolment for the same term" do
    sign_in
    create_enrolment

    assert_no_difference("Enrolment.count") do
      post enrolments_path, params: {
        enrolment: {
          student_id: @student.id,
          unit_id: @unit.id,
          semester: "Semester 1",
          academic_year: 2026
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /already enrolled/
  end

  test "deletes an enrolment without a result" do
    sign_in
    enrolment = create_enrolment

    assert_difference("Enrolment.count", -1) do
      delete enrolment_path(enrolment)
    end

    assert_redirected_to student_path(@student)
    follow_redirect!
    assert_select ".notice", text: /successfully removed/
  end

  test "preserves enrolments with results" do
    sign_in
    enrolment = create_enrolment
    result = Result.create!(enrolment: enrolment, mark: 85, grade: "HD")

    assert_no_difference("Enrolment.count") do
      delete enrolment_path(enrolment)
    end

    assert Enrolment.exists?(enrolment.id)
    assert Result.exists?(result.id)
    assert_redirected_to student_path(@student)
    follow_redirect!
    assert_select ".alert-error", text: /academic result is recorded/
  end

  test "redirects unauthenticated users from every enrolment action" do
    enrolment = create_enrolment

    get enrolments_path
    assert_redirected_to login_path
    get new_enrolment_path
    assert_redirected_to login_path
    get enrolment_path(enrolment)
    assert_redirected_to login_path
    post enrolments_path, params: { enrolment: { student_id: @student.id, unit_id: @unit.id, semester: "Semester 1", academic_year: 2026 } }
    assert_redirected_to login_path
    delete enrolment_path(enrolment)
    assert_redirected_to login_path

    assert Enrolment.exists?(enrolment.id)
  end

  private

  def sign_in
    post login_path, params: { username: @user.username, password: "secure-password" }
    assert_redirected_to root_path
  end

  def create_enrolment
    Enrolment.create!(student: @student, unit: @unit, semester: "Semester 1", academic_year: 2026)
  end
end
