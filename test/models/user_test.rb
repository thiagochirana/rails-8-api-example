require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    assert_not duplicate_user.valid?
  end

  test "document_number should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = "new_email@example.com"
    assert_not duplicate_user.valid?
  end

  test "password should be present on create" do
    user = User.new(email: "test@example.com", password: "", password_confirmation: "")
    assert_not user.valid?
  end

  test "password should have a minimum length" do
    user = User.new(email: "test@example.com", password: "1234567", password_confirmation: "1234567")
    assert_not user.valid?
  end

  test "password should not contain spaces" do
    user = User.new(email: "test@example.com", password: "1234 5678", password_confirmation: "1234 5678")
    assert_not user.valid?
  end

  test "password should not contain invalid chars" do
    user = User.new(email: "test@example.com", password: "senhaç123", password_confirmation: "senhaç123")
    assert_not user.valid?
  end

  test "should set role to user by default" do
    new_user = User.new(email: "test@example.com", password: "password123")
    new_user.valid?
    assert_equal "user", new_user.role
  end

  test "authentication should work with email" do
    assert_equal @user, User.authenticating(login: @user.email, password: "12345678")
  end

  test "authentication should work with document_number" do
    assert_equal @user, User.authenticating(login: @user.document_number, password: "12345678")
  end

  test "authentication should fail with incorrect password" do
    assert_nil User.authenticating(login: @user.email, password: "wrongpassword")
  end
end
