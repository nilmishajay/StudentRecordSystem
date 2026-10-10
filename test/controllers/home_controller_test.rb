require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated visitors to login" do
    get root_path

    assert_redirected_to login_path
  end

  test "authenticated user can view the dashboard" do
    user = User.create!(username: "dashboard-user", email: "dashboard@example.com", password: "secure-password")
    post login_path, params: { username: user.username, password: "secure-password" }

    get root_path
    assert_response :success
    assert_select "h1", text: /Welcome back, #{user.username}/
    assert_select "header", text: /Edith Cowan University/
    assert_select ".brand-copy", text: /Student Academic Records Portal/
    assert_select ".sidebar-navigation a[href=?][aria-current='page']", root_path
    assert_select ".stat-card", 5
    assert_select ".stat-card", text: /Students/
    assert_select ".stat-card", text: /Enrolments/
    assert_select ".stat-card", text: /Results/
  end
end
