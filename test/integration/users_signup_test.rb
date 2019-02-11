require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "signup posts to valid url test" do
    get signup_path
    assert_select 'form[action="/signup"]'
  end

  test "invalid signup test" do
    #compares User.count before and after executing the block
    assert_no_difference 'User.count' do
      post users_path, params: { 
        user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end
    assert_template 'users/new'
    assert_select "div.alert-danger", "The form contains 4 errors."
    assert_select "div#error_explanation"
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: { name: "Example User",
                                        email: "user@example.de",
                                        password: "password",
                                        password_confirmation: "password" } }
    end
    #user is logged in immediately after signup
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

  test "valid signup test" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: "Firstname",
          email: "fn.ln@prov.test",
          password: "foobar",
          password_confirmation: "foobar"
        }
      }
    end
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
  end
end
