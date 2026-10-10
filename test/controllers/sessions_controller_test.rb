require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "shows the login page at the login route" do
    get login_path

    assert_response :success
    assert_select "form[action='#{login_path}']"
    assert_select "h1", text: "Student Academic Records Portal"
    assert_select "p", text: "Edith Cowan University"
    assert_select "input[type='text'][name='username'][autocomplete='username']"
    assert_select "input[type='password'][name='password']"
    assert_select "input[type='submit'][value='Sign in']"
  end

  test "rejects invalid login credentials" do
    post login_path, params: { username: "missing-user", password: "wrong-password" }

    assert_response :unprocessable_entity
    assert_select ".alert", text: /Invalid username or password/
  end

  test "logs in with valid credentials" do
    user = User.create!(username: "login-user", email: "login@example.com", password: "secure-password")

    post login_path, params: { username: user.username, password: "secure-password" }

    assert_redirected_to root_path
    get root_path
    assert_response :success
  end

  test "logs in with the email address shown on the login page" do
    user = User.create!(username: "email-login-user", email: "email-login@example.com", password: "secure-password")

    post login_path, params: { email: user.email, password: "secure-password" }

    assert_redirected_to root_path
    get root_path
    assert_response :success
    assert_select "h1", text: /Welcome back, #{user.username}/
  end

  test "administrator can submit a username without browser email validation" do
    admin = User.create!(username: "admin", email: "admin@example.com", password: "secure-password", role: "admin")

    get login_path
    assert_select "input[type='text'][name='username']"

    post login_path, params: { username: admin.username, password: "secure-password" }

    assert_redirected_to root_path
    get root_path
    assert_response :success
    assert_select "h1", text: /Welcome back, admin/
  end

  test "logs out and redirects to login" do
    delete logout_path

    assert_redirected_to login_path
    follow_redirect!
    assert_response :success
  end
end
