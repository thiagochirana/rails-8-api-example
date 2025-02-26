require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should login with valid credentials" do
    post login_path, params: { login: @user.email, password: "12345678" }
    assert_response :success
    assert_includes @response.body, "access_token"

    @access_token = @response.body["access_token"]
  end

  test "should not login with invalid credentials" do
    post login_path, params: { login: @user.email, password: "wrongpassword" }
    assert_response :unauthorized
    assert_equal "Login e senha inválidos", @response.body
  end

  test "should return errors if user has validation errors" do
    User.stubs(:errors).returns(OpenStruct.new(any?: true, full_messages: ["Erro de validação"]))
    post login_path, params: { login: @user.email, password: "12345678" }
    assert_response :unauthorized
    assert_includes @response.body, "Erro de validação"
  end

  test "should refresh token" do
    put refresh_path, headers: { "Authorization": "Bearer #{@access_token}"}
    assert_includes @response.body, "access_token"
    assert_response :success
  end
end
