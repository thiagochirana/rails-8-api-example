require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should register a new user" do
    post register_url, params: {
      firstname: "New",
      lastname: "User",
      birthday: "2000-01-01",
      document_number: CPF.generate,
      email: "newuser@example.com",
      password: "password123",
      password_confirmation: "password123"
    }
    assert_response :created
  end

  test "should not register with invalid data" do
    post register_url, params: { email: "invalid" }
    assert_response :bad_request
  end
end
