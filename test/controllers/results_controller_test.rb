require "test_helper"

class ResultsControllerTest < ActionDispatch::IntegrationTest
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
    @enrolment = Enrolment.create!(student: @student, unit: @unit, semester: "Semester 1", academic_year: 2026)
    @other_unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Other Unit", credit: 10, course: @course)
    @other_enrolment = Enrolment.create!(student: @student, unit: @other_unit, semester: "Semester 1", academic_year: 2026)
    @user = User.create!(
      username: "results-user-#{SecureRandom.hex(4)}",
      email: "results-user-#{SecureRandom.hex(4)}@example.com",
      password: "secure-password"
    )
  end

  test "authenticated user can view results, create form, result details and edit form" do
    sign_in
    result = create_result

    get results_path
    assert_response :success
    assert_select "a[href=?]", result_path(result), text: "View"

    get new_result_path(enrolment_id: @other_enrolment.id)
    assert_response :success
    assert_select "select[name='result[enrolment_id]'] option[selected][value=?]", @other_enrolment.id.to_s

    get result_path(result)
    assert_response :success
    assert_select ".detail-value", text: /#{@student.student_number}/
    assert_select ".detail-value", text: /#{@unit.code}/
    assert_select ".detail-value", text: "Semester 1"
    assert_select ".detail-value", text: "2026"

    get edit_result_path(result)
    assert_response :success
    assert_select "select[name='result[enrolment_id]'] option[selected][value=?]", @enrolment.id.to_s
  end

  test "creates a result and reports success" do
    sign_in

    assert_difference("Result.count", 1) do
      post results_path, params: { result: { enrolment_id: @enrolment.id, mark: "87.25", grade: "HD" } }
    end

    result = Result.find_by!(enrolment: @enrolment)
    assert_redirected_to result_path(result)
    follow_redirect!
    assert_select ".notice", text: /successfully recorded/
    assert_select ".detail-value", text: "87.25"
    assert_select ".detail-value", text: "HD"
  end

  test "shows helpful errors for missing or invalid result values" do
    sign_in

    [ nil, "-1", "100.01", "not-a-mark" ].each do |mark|
      assert_no_difference("Result.count") do
        post results_path, params: { result: { enrolment_id: @enrolment.id, mark: mark, grade: "D" } }
      end
      assert_response :unprocessable_entity
      assert_select ".alert-error", text: /Mark/
    end

    assert_no_difference("Result.count") do
      post results_path, params: { result: { enrolment_id: @enrolment.id, mark: "70", grade: "" } }
    end
    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Grade can't be blank/

    assert_no_difference("Result.count") do
      post results_path, params: { result: { enrolment_id: 9_999_999, mark: "70", grade: "D" } }
    end
    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Enrolment must exist/
  end

  test "prevents duplicate results for an enrolment" do
    sign_in
    create_result

    assert_no_difference("Result.count") do
      post results_path, params: { result: { enrolment_id: @enrolment.id, mark: "90", grade: "HD" } }
    end

    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /already has a recorded result/
  end

  test "updates a result and can move it to another ungraded enrolment" do
    sign_in
    result = create_result

    patch result_path(result), params: { result: { enrolment_id: @other_enrolment.id, mark: "90.5", grade: "Updated grade" } }

    assert_redirected_to result_path(result)
    assert_equal @other_enrolment, result.reload.enrolment
    assert_equal BigDecimal("90.5"), result.mark
    assert_equal "Updated grade", result.grade
  end

  test "renders validation errors and preserves result values on invalid update" do
    sign_in
    result = create_result

    patch result_path(result), params: { result: { mark: "101", grade: "" } }

    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /Mark/
    assert_select ".alert-error", text: /Grade can't be blank/
    assert_equal BigDecimal("70"), result.reload.mark
    assert_equal "D", result.grade
  end

  test "prevents an update that would duplicate another result" do
    sign_in
    result = create_result
    other_result = Result.create!(enrolment: @other_enrolment, mark: 80, grade: "D")

    patch result_path(result), params: { result: { enrolment_id: @other_enrolment.id, mark: 95, grade: "HD" } }

    assert_response :unprocessable_entity
    assert_select ".alert-error", text: /already has a recorded result/
    assert_equal @enrolment, result.reload.enrolment
    assert Result.exists?(other_result.id)
  end

  test "displays weighted WAM, excludes ungraded units, and shows unavailable without marks" do
    sign_in
    @unit.update!(credit: 10)
    @other_unit.update!(credit: 30)
    create_result(mark: "80.00", grade: "D")
    Result.create!(enrolment: @other_enrolment, mark: "70.00", grade: "D")
    ungraded_unit = Unit.create!(code: "UNIT-#{SecureRandom.hex(4)}", name: "Ungraded Unit", credit: 100, course: @course)
    Enrolment.create!(student: @student, unit: ungraded_unit, semester: "Semester 2", academic_year: 2026)

    get student_path(@student)
    assert_response :success
    assert_select ".detail-value", text: "72.50"
    assert_select ".data-table", text: /No result recorded/
    assert_select ".data-table", text: /Ungraded Unit/

    other_student = Student.create!(
      student_number: "STUDENT-#{SecureRandom.hex(4)}",
      first_name: "No",
      last_name: "Marks",
      email: "no-marks-#{SecureRandom.hex(4)}@example.com",
      course: @course
    )
    get student_path(other_student)
    assert_select ".detail-value", text: "Not available"
  end

  test "redirects unauthenticated users from result actions" do
    result = create_result

    get results_path
    assert_redirected_to login_path
    get new_result_path
    assert_redirected_to login_path
    get result_path(result)
    assert_redirected_to login_path
    get edit_result_path(result)
    assert_redirected_to login_path
    post results_path, params: { result: { enrolment_id: @other_enrolment.id, mark: "70", grade: "D" } }
    assert_redirected_to login_path
    patch result_path(result), params: { result: { mark: "99", grade: "HD" } }
    assert_redirected_to login_path

    assert_equal BigDecimal("70"), result.reload.mark
  end

  private

  def sign_in
    post login_path, params: { username: @user.username, password: "secure-password" }
    assert_redirected_to root_path
  end

  def create_result(mark: "70", grade: "D")
    Result.create!(enrolment: @enrolment, mark: mark, grade: grade)
  end
end
