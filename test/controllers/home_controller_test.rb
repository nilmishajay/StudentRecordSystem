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
    assert_select "strong", text: user.username
  end
end
